// short script to compare the reference and the current output the
// RunExamples.sh test

#include "TFile.h"
#include "TH1F.h"
#include <iostream>

int compareReference(const char *testFileName, const char *refFileName,
                     const char *treeName = "Tree") {
  TFile *fileTest = TFile::Open(testFileName);
  TFile *fileRef = TFile::Open(refFileName);
  TTree *treeTest = (TTree *)fileTest->Get(treeName);
  TTree *treeRef = (TTree *)fileRef->Get(treeName);

  if (!treeTest || !treeRef) {
    std::cerr << "Error: Tree " << treeName << " not found in one of the files."
              << std::endl;
    return 1;
  }

  if (treeTest->GetEntries() != treeRef->GetEntries()) {
    std::cerr << "Error: Number of entries in tree " << treeName
              << " does not match." << std::endl;
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

  TH1F *hmumuMassTest = new TH1F("hmumuMassTest", "mumuMass", 100, 0, 5.);
  TH1F *hmumuMassRef = new TH1F("hmumuMassRef", "mumuMass", 100, 0, 5.);

  treeTest->Draw("mumuMass>>hmumuMassTest");
  treeRef->Draw("mumuMass>>hmumuMassRef");

  TCanvas *c0 = new TCanvas("c0", "Comparison of mumuMass", 800, 600);
  c0->cd();
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
    float ratio = ratioTestRef->GetBinContent(i);
    if (std::abs(ratio - 1.0) > 0.0001 && ratioTestRef->GetBinContent(i) != 0) {
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

  return 0;
}
