filename = 'sample3.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G=zeros(N,N);
G(1:Size)=pixel(1:Size);
G=permute(G, [2,1]);

% imshow(G, [0,255]);

window1 = 3;
b = 2;
mask = [1 b 1; b b^2 b; 1 b 1] / (b+2)^2;
afterpad1 = zeros(int64(N)+(window1-1));
afterpad1(1+floor(window1/2):end-floor(window1/2), 1+floor(window1/2):end-floor(window1/2)) = G;
afterpad1(1,:) = afterpad1(3,:);
afterpad1(end,:) = afterpad1(end-2, :);
afterpad1(:, 1) = afterpad1(:, 3);
afterpad1(:, end) = afterpad1(:, end-2);
afterpad1(1,1) = afterpad1(3, 3);
afterpad1(end,end) = afterpad1(end-2, end-2);
afterpad1(1, end) = afterpad1(3, end-2);
afterpad1(end, 1) = afterpad1(end-2, 3);
G_new = zeros(N,N);
for i = 1+floor(window1/2):size(afterpad1, 1)-floor(window1/2)
	for j = 1+floor(window1/2):size(afterpad1, 2)-floor(window1/2)
		temp = afterpad1(i-floor(window1/2):i+floor(window1/2), j-floor(window1/2):j+floor(window1/2));
		temp2 = 0;
		for k = 1:9
			temp2 = temp2 + temp(k) * mask(k);
		end
		G_new(i-floor(window1/2), j-floor(window1/2)) = temp2;
	end
end

c = 0.6;
G_2a = round(G * (c/(2*c-1)) - G_new * ((1-c)/(2*c-1)));

% figure;
% imshow(G_2a, [0,255]);
% imwrite(uint8(G_2a), 'G_2a_06_3b.jpg');
fid2=fopen('2a.raw','wb');
Towrite=permute(G_2a, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);