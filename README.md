Proposed method can be used by running CurveAlign.m in curvelets folder. 
  Detailed instruction of the graphical user interface is in the paper.
SIFT can be used by running main_registration.mlx in SIFT-matlab-V1.0 folder. 
  File path need to point to the corresponding path storing the dataset. (HE_512 and SHG_512_not_adjusted)
  Comment out the segmentation part if testing the raw HE input.
PSO-SIFT can be used by running main_registration.mlx in PSO-SIFT-matlab-V1.0 folder. 
  File path need to point to the corresponding path storing the dataset. (HE_512 and SHG_512_not_adjusted)
  Comment out the segmentation part if testing the raw HE input.
Elastix can be used by running elastix_affine.py. 
  SimpleElastix and all dependencies need to be installed. https://simpleelastix.github.io/. 
  File path need to point to the corresponding path storing the dataset. (HE_512 and SHG_512_adjusted for raw HE input)
  File path need to point to the corresponding path storing the dataset. (ECM and SHG_512_adjusted for raw HE input)