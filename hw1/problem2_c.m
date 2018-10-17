filename='G1.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G1=zeros(N,N);
G1(1:Size)=pixel(1:Size);
G1=permute(G1, [2,1]);


filename='S1.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
S1=zeros(N,N);
S1(1:Size)=pixel(1:Size);
S1=permute(S1, [2,1]);


% RG part
window1 = 3;
b = 2;
mask = [1 b 1; b b^2 b; 1 b 1] / (b+2)^2;
afterpad1 = zeros(int64(N)+(window1-1));
afterpad1(1+floor(window1/2):end-floor(window1/2), 1+floor(window1/2):end-floor(window1/2)) = G1;
afterpad1(1,:) = afterpad1(3,:);
afterpad1(end,:) = afterpad1(end-2, :);
afterpad1(:, 1) = afterpad1(:, 3);
afterpad1(:, end) = afterpad1(:, end-2);
afterpad1(1,1) = afterpad1(3, 3);
afterpad1(end,end) = afterpad1(end-2, end-2);
afterpad1(1, end) = afterpad1(3, end-2);
afterpad1(end, 1) = afterpad1(end-2, 3);
RG = zeros(N,N);
for i = 1+floor(window1/2):size(afterpad1, 1)-floor(window1/2)
	for j = 1+floor(window1/2):size(afterpad1, 2)-floor(window1/2)
		temp = afterpad1(i-floor(window1/2):i+floor(window1/2), j-floor(window1/2):j+floor(window1/2));
		temp2 = 0;
		for k = 1:9
			temp2 = temp2 + temp(k) * mask(k);
		end
		RG(i-floor(window1/2), j-floor(window1/2)) = temp2;
	end
end

% window2 = 5;
% b = 2;
% mask = [1 4 7 4 1; 4 16 26 16 4; 7 26 41 26 7; 4 16 26 16 4; 1 4 7 4 1] / 273;
% afterpad2 = zeros(int64(N)+(window2-1));
% afterpad2(1+floor(window2/2):end-floor(window2/2), 1+floor(window2/2):end-floor(window2/2)) = G1;
% for i = 1:2
% 	afterpad2(i,:) = afterpad2(6-i,:);
% 	afterpad2(end-i+1,:) = afterpad2(end-5+i, :);
% 	afterpad2(:, i) = afterpad2(:, 6-i);
% 	afterpad2(:, end-i+1) = afterpad2(:, end-5+i);
% 	afterpad2(i,i) = afterpad2(6-i, 6-i);
% 	afterpad2(end-i+1,end-i+1) = afterpad2(end-5+i, end-5+i);
% 	afterpad2(i, end-i+1) = afterpad2(6-i, end-5+i);
% 	afterpad2(end-i+1, i) = afterpad2(end-5+i, 6-i);
% end
% RG = zeros(N,N);
% for i = 1+floor(window2/2):size(afterpad2, 1)-floor(window2/2)
% 	for j = 1+floor(window2/2):size(afterpad2, 2)-floor(window2/2)
% 		temp = afterpad2(i-floor(window2/2):i+floor(window2/2), j-floor(window2/2):j+floor(window2/2));
% 		temp2 = 0;
% 		for k = 1:25
% 			temp2 = temp2 + temp(k) * mask(k);
% 		end
% 		RG(i-floor(window2/2), j-floor(window2/2)) = temp2;
% 		% RS(i-floor(window2/2), j-floor(window2/2)) = median(sort(reshape(temp, [1,25])));
% 	end
% end
imshow(RG, [0,255]);
%save RG
fid2=fopen('RG.raw','wb');
Towrite=permute(RG, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);



% window2 = 5;
% afterpad2 = zeros(int64(N)+(window2-1));
% afterpad2(1+floor(window2/2):end-floor(window2/2), 1+floor(window2/2):end-floor(window2/2)) = S1;
% for i = 1:2
% 	afterpad2(i,:) = afterpad2(6-i,:);
% 	afterpad2(end-i+1,:) = afterpad2(end-5+i, :);
% 	afterpad2(:, i) = afterpad2(:, 6-i);
% 	afterpad2(:, end-i+1) = afterpad2(:, end-5+i);
% 	afterpad2(i,i) = afterpad2(6-i, 6-i);
% 	afterpad2(end-i+1,end-i+1) = afterpad2(end-5+i, end-5+i);
% 	afterpad2(i, end-i+1) = afterpad2(6-i, end-5+i);
% 	afterpad2(end-i+1, i) = afterpad2(end-5+i, 6-i);
% end
% RS = zeros(N,N);
% for i = 1+floor(window2/2):size(afterpad2, 1)-floor(window2/2)
% 	for j = 1+floor(window2/2):size(afterpad2, 2)-floor(window2/2)
% 		% disp([i j])
% 		temp = afterpad2(i-floor(window2/2):i+floor(window2/2), j-floor(window2/2):j+floor(window2/2));
% 		% disp(temp)
% 		RS(i-floor(window2/2), j-floor(window2/2)) = median(sort(reshape(temp, [1,25])));
% 	end
% end

window2 = 3;
afterpad2 = zeros(int64(N)+(window2-1));
afterpad2(1+floor(window2/2):end-floor(window2/2), 1+floor(window2/2):end-floor(window2/2)) = S1;
afterpad2(1,:) = afterpad2(3,:);
afterpad2(end,:) = afterpad2(end-2, :);
afterpad2(:, 1) = afterpad2(:, 3);
afterpad2(:, end) = afterpad2(:, end-2);
afterpad2(1,1) = afterpad2(3, 3);
afterpad2(end,end) = afterpad2(end-2, end-2);
afterpad2(1, end) = afterpad2(3, end-2);
afterpad2(end, 1) = afterpad2(end-2, 3);
RS = zeros(N,N);
for i = 1+floor(window2/2):size(afterpad2, 1)-floor(window2/2)
	for j = 1+floor(window2/2):size(afterpad2, 2)-floor(window2/2)
		% disp([i j])
		temp = afterpad2(i-floor(window2/2):i+floor(window2/2), j-floor(window2/2):j+floor(window2/2));
		% disp(temp)
		RS(i-floor(window2/2), j-floor(window2/2)) = median(sort(reshape(temp, [1,9])));
	end
end
imshow(RS, [0,255]);
%save RS
fid2=fopen('RS.raw','wb');
Towrite=permute(RS, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);