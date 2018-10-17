% DIP Homework Assignment #1
% Mar,27,2018
% Name: Huang Song Ren
% ID #: B04902099
% email: b04902099@ntu.edu.tw
% matlab version: R2017b
%###############################################################################%
% WARM-UP
% Implementation: Color to gray and flipping
% M-file name: warm_up.m
% Input: sample1.raw
% Output: I1_gray.raw and B.raw
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run warm_up.m"
disp("running warm_up");
warm_up;
disp('Done, "warm_up", output image are "I1_gray.raw and B.raw"');
%###############################################################################%
% Problem 1(a):
% Implementation: Decrease the brightness
% M-file name: problem1_a.m
% Input: sample2.raw (in the same folder with code)
% Output: D.raw
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem1_a.m"
disp("running problem1_a");
problem1_a;
disp('Done, "problem1_a", output image is "D.raw"');
%###############################################################################%
% Problem 1(b):
% Implementation: Plot the histograms
% M-file name: problem1_b.m
% Input: sample2.raw and D.raw (in the same folder with code)
% Output: Histogram_I2.jpg and Histogram_D.jpg
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem1_b.m"
disp("running problem1_b");
problem1_b;
disp('Done, "problem1_b", output image are "Histogram_I2.jpg and Histogram_D.jpg"');
%###############################################################################%
% Problem 1(c):
% Implementation: histogram equalization
% M-file name: problem1_c.m
% Input: D.raw (in the same folder with code)
% Output: H.raw
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem1_c.m"
disp("running problem1_c");
problem1_c;
disp('Done, "problem1_c", output image is "H.raw"');
%###############################################################################%
% Problem 1(d):
% Implementation: local histogram equalization
% M-file name: problem1_d.m
% Input: D.raw (in the same folder with code)
% Output: L.raw
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem1_d.m"
disp("running problem1_d");
problem1_d;
disp('Done, "problem1_d", output image is "L.raw"');
%###############################################################################%
% Problem 1(e):
% Implementation: Plot the histograms of H and L
% M-file name: problem1_e.m
% Input: H.raw and L.raw (in the same folder with code)
% Output: Histogram_H.jpg and Histogram_L.jpg
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem1_e.m"
disp("running problem1_e");
problem1_e;
disp('Done, "problem1_e", output image are "Histogram_H.jpg and Histogram_L.jpg"');
%###############################################################################%
% Problem 1(f):
% Implementation: log transform, inverse log transform and power-law transform
% M-file name: problem1_f.m
% Input: D.raw (in the same folder with code)
% Output: log.raw, Histogram_log.jpg, inv.raw, Histogram_inv.jpg, power.raw, Histogram_power.jpg
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem1_f.m"
disp('running "problem1_f"');
problem1_f;
disp('Done, "problem1_f", output image are "log.raw, Histogram_log.jpg, inv.raw, Histogram_inv.jpg, power.raw, Histogram_power.jpg"');
%###############################################################################%
% Problem 2(I)(a):
% Implementation: adding Gaussian noise
% M-file name: problem2_a.m
% Input: sample3.raw (in the same folder with code)
% Output: G1.raw and G2.raw
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem2_a.m"
disp("running problem2_a");
problem2_a;
disp('Done, "problem2_a", output image are "G1.raw and G2.raw"');
%###############################################################################%
% Problem 2(I)(b):
% Implementation: adding salt-and-pepper noise
% M-file name: problem2_b.m
% Input: sample3.raw (in the same folder with code)
% Output: S1.raw and S2.raw
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem2_b.m"
disp("running problem2_b");
problem2_b;
disp('Done, "problem2_b", output image are "S1.raw and S2.raw"');
%###############################################################################%
% Problem 2(I)(c):
% Implementation: remove noise from G1 and S1
% M-file name: problem2_c.m
% Input: G1.raw and S1.raw (in the same folder with code)
% Output: RG.raw and RS.raw
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem2_c.m"
disp("running problem2_c");
problem2_c;
disp('Done, "problem2_c", output image are "RG.raw and RS.raw"');
%###############################################################################%
% Problem 2(I)(d):
% Implementation: Compute the PSNR
% M-file name: problem2_d.m
% Input: sample3.raw, RG.raw, RS.raw (in the same folder with code)
% Output: two PSNR value
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem2_d.m"
disp("running problem2_d");
problem2_d;
disp('Done, "problem2_d", no output image');
%###############################################################################%
% Problem 2(II):
% Implementation: remove the wrinkles
% M-file name: problem2_wrinkles.m
% Input: sample4.raw (in the same folder with code)
% Output: W.raw
% How to excute(in unix bash): matlab -nodesktop -nodisplay -r "run problem2_wrinkles.m"
disp("running problem2_wrinkles");
problem2_wrinkles;
disp('Done, "problem2_wrinkles", output image is "W.raw"');
%###############################################################################%