filename = 'sample4.raw';
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
[count,bin] = hist(G(:), 0:255);
% stem(bin,count, 'Marker','none');
% disp(find(count == max(count)));

TD = find(count == max(count))+40;
G_out = G;
for i = 1:N
	for j = 1:N
		if G(i,j) > 10 && G(i,j) < TD
			G_out(i,j) = 0;
		end
	end
end
% figure;
% imshow(G_out, [0,255]);

window1 = 3;
b = 2;
mask = [1 b 1; b b^2 b; 1 b 1] / (b+2)^2;
afterpad1 = zeros(int64(N)+(window1-1));
afterpad1(1+floor(window1/2):end-floor(window1/2), 1+floor(window1/2):end-floor(window1/2)) = G_out;
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
G_bonus1 = G_out * (c/(2*c-1)) - G_new * ((1-c)/(2*c-1));

% figure;
% imshow(G_bonus1, [0,255]);
% imwrite(uint8(G_bonus1), 'G_bonus1.jpg');
fid2=fopen('bonus_a.raw','wb');
Towrite=permute(G_bonus1, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);


%pic2
filename = 'sample5.raw';
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
[count,bin] = hist(G(:), 0:255);
% stem(bin,count, 'Marker','none');
% disp(find(count == max(count)));

TD = find(count == max(count))+40;
G_out = G;
for i = 1:N
	for j = 1:N
		if G(i,j) > 10 && G(i,j) < TD
			G_out(i,j) = 0;
		end
	end
end
% figure;
% imshow(G_out, [0,255]);

window1 = 3;
b = 2;
mask = [1 b 1; b b^2 b; 1 b 1] / (b+2)^2;
afterpad1 = zeros(int64(N)+(window1-1));
afterpad1(1+floor(window1/2):end-floor(window1/2), 1+floor(window1/2):end-floor(window1/2)) = G_out;
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
G_bonus2 = G_out * (c/(2*c-1)) - G_new * ((1-c)/(2*c-1));

% figure;
% imshow(G_bonus2, [0,255]);
% imwrite(uint8(G_bonus2), 'G_bonus2.jpg');
fid2=fopen('bonus_b.raw','wb');
Towrite=permute(G_bonus2, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);