// short script to compare the reference and the current output of the
// RunExamples.sh test

#include "TFile.h"
#include "TH1F.h"
#include "TCanvas.h"
#include "TTree.h"
#include <iostream>
#include <cmath>

int compareReference(const char *testFileName, const char *refFileName,
                     const char *treeName = "Tree") {
  TFile *fileTest = TFile::Open(testFileName);
  TFile *fileRef = TFile::Open(refFileName);
  if (!fileTest || fileTest->IsZombie()) {
    std::cerr << "Error: Unable to open test file " << testFileName << std::endl;
    if (fileTest) { fileTest->Close(); delete fileTest; }
    if (fileTest) fileTest->Close();
    return 1;
  }
  if (!fileRef || fileRef->IsZombie()) {
    std::cerr << "Error: Unable to open reference file " << refFileName << std::endl;
    fileTest->Close();
    delete fileTest;
    if (fileRef) { fileRef->Close(); delete fileRef; }
    if (fileRef) fileRef->Close();
    return 1;
  }
  TTree *treeTest = (TTree *)fileTest->Get(treeName);
  TTree *treeRef = (TTree *)fileRef->Get(treeName);

  if (!treeTest || !treeRef) {
    std::cerr << "Error: Tree " << treeName << " not found in one of the files."
              << std::endl;
    fileTest->Close();
    fileRef->Close();
    delete fileTest;
    delete fileRef;
    return 1;
  }

  if (treeTest->GetEntries() != treeRef->GetEntries()) {
    std::cerr << "Error: Number of entries in tree " << treeName
              << " does not match." << std::endl;
    fileTest->Close();
    fileRef->Close();
    delete fileTest;
    delete fileRef;
    return 1;
  }

  // Here you can add more detailed comparisons of the tree contents if needed
  std::cout << "Tree entries in the reference file = " << treeRef->GetEntries()
            << std::endl;
  std::cout << "Tree entries in the test file = " << treeTest->GetEntries()
            << std::endl;
  std::cout
      << "Comparison successful: The number of entries in the tree matches."
      << std::endl;


  // FIXME: this is a temporary demonstration of how to compare the contents of the tree
  // to be replaced with a more detailed comparison of the relevant variables
  // for example distributions that include the gen-level or gen-matched variables

  TH1F *hmumuMassTest = new TH1F("hmumuMassTest", "mumuMass", 100, 0, 5.);
  TH1F *hmumuMassRef = new TH1F("hmumuMassRef", "mumuMass", 100, 0, 5.);

  treeTest->Draw("mumuMass>>hmumuMassTest");
  treeRef->Draw("mumuMass>>hmumuMassRef");

  TH1F *ratioTestRef = (TH1F *)hmumuMassTest->Clone("ratioTestRef");
  ratioTestRef->Divide(hmumuMassRef);
  TCanvas *c1 = new TCanvas("c1", "Comparison of mumuMass", 800, 600);
  ratioTestRef->SetTitle("Ratio of mumuMass (Test/Reference)");
  ratioTestRef->GetXaxis()->SetTitle("mumuMass (GeV)");
  ratioTestRef->GetYaxis()->SetTitle("Ratio");
  ratioTestRef->Draw("E");
  c1->SaveAs("ValidationReducer_mumuMass_Comparison.png");

  // test that the ratio is close to 1 within some tolerance
  bool comparisonPassed = true;
  for (int i = 1; i <= ratioTestRef->GetNbinsX(); ++i) {
    // Use the original histograms to decide how to treat this bin
    double testBin = hmumuMassTest->GetBinContent(i);
    double refBin  = hmumuMassRef->GetBinContent(i);

    // If both histograms are empty in this bin, skip it
    if (testBin == 0.0 && refBin == 0.0) {
      continue;
    }

    // If the reference is empty but the test is not, this is a clear discrepancy
    if (refBin == 0.0 && testBin != 0.0) {
      comparisonPassed = false;
      std::cerr << "Warning: Bin " << i
                << " has entries in the test histogram but none in the reference."
                << std::endl;
      continue;
    }

    float ratio = ratioTestRef->GetBinContent(i);
    if (std::abs(ratio - 1.0) > 0.0001) {
      comparisonPassed = false;
      std::cerr << "Warning: Bin " << i << " has a ratio of " << ratio
                << ", which is outside the tolerance." << std::endl;
    }
  }
  if (comparisonPassed) {
    std::cout << "Comparison successful: The ratio of mumuMass is within the "
                 "tolerance."
              << std::endl;
  } else {
    std::cerr
        << "Comparison failed: Some bins have a ratio outside the tolerance."
        << std::endl;
  }

  delete c0;
  delete c1;
  delete ratioTestRef;
  delete hmumuMassTest;
  delete hmumuMassRef;
  fileTest->Close();
  fileRef->Close();
  delete fileTest;
  delete fileRef;

  return 0;
  fileTest->Close();
  fileRef->Close();
  return comparisonPassed ? 0 : 1;
}
