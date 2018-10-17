% DIP Homework Assignment #2
% April,9,2018
% Name: Huang Song Ren
% ID #: B04902099
% email: b04902099@ntu.edu.tw
% matlab version: R2017b
%###############################################################################%
% Problem 1(a)
% Implementation: edge detection
% M-file name: problem1_a.m
% Input: sample1.raw (should be in the same folder with code)
% Output: 1a_1st.raw, 1a_2nd.raw, 1a_canny.raw
% Usage: problem1_a
% parameter: TD3P=30, TD4P=40, TD9P=40, window1=3, b=1, TD=2, K=2, TL=10, TH=40
disp("running problem1_a");
problem1_a;
disp('Done, "problem1_a", output image are "1a_1st.raw, 1a_2nd.raw, 1a_canny.raw"');
%###############################################################################%
% Problem 1(b)
% Implementation: edge detection with periodic noise
% M-file name: problem1_b.m
% Input: sample2.raw (should be in the same folder with code)
% Output: 1b.raw
% Usage: problem1_b
% parameter: window1=3, b=2, K=1, TH=35, TD=10
disp("running problem1_b");
problem1_b;
disp('Done, "problem1_b", output image are "1b.raw"');
%###############################################################################%
% Problem 2(a)
% Implementation: edge crispening
% M-file name: problem2_a.m
% Input: sample3.raw (should be in the same folder with code)
% Output: 2a.raw
% Usage: problem2_a
% parameter: window1=3, b=2, c=0.6
disp("running problem2_a");
problem2_a;
disp('Done, "problem2_a", output image are "2a.raw"');
%###############################################################################%
% Problem 2(b)
% Implementation: image warping
% M-file name: problem2_b.m
% Input: sample3.raw (should be in the same folder with code)
% Output: 2b.raw
% Usage: problem2_b
% parameter: parameter_a=40, parameter_b=135, parameter_c=20, parameter_d = 180
disp("running problem2_b");
problem2_b;
disp('Done, "problem2_b", output image are "2b.raw"');
%###############################################################################%
% bonus
% Implementation: image enhancement
% M-file name: bonus.m
% Input: sample4.raw, sample5.raw (should be in the same folder with code)
% Output: bonus_a.raw, bonus_b.raw
% Usage: bonus
% parameter: window1=3, b=2, c=0.6, TD(vary with image)
disp("running bonus");
bonus;
disp('Done, "bonus", output image are "bonus_a.raw, bonus_b.raw"');
%###############################################################################%