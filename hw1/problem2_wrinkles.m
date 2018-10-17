filename='sample4.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G=zeros(N,N);
G(1:Size)=pixel(1:Size);
G=permute(G, [2,1]);
imshow(G, [0,255]);	

window2 = 9;
afterpad2 = G;
afterpad2 = zeros(int64(N)+(window2-1));
afterpad2(1+floor(window2/2):end-floor(window2/2), 1+floor(window2/2):end-floor(window2/2)) = G;
for i = 1:floor(window2/2)
	afterpad2(i,:) = afterpad2(2*floor(window2/2)-i+1,:);
	afterpad2(end-i+1,:) = afterpad2(end-2*floor(window2/2)-i+1, :);
	afterpad2(:, i) = afterpad2(:, floor(window2/2)-i+1);
	afterpad2(:, end-i+1) = afterpad2(:, end-2*floor(window2/2)-i+1);
	afterpad2(i,i) = afterpad2(floor(window2/2)-i+1, floor(window2/2)-i+1);
	afterpad2(end-i+1,end-i+1) = afterpad2(end-2*floor(window2/2)-i+1, end-2*floor(window2/2)-i+1);
	afterpad2(i, end-i+1) = afterpad2(floor(window2/2)-i+1, end-2*floor(window2/2)-i+1);
	afterpad2(end-i+1, i) = afterpad2(end-2*floor(window2/2)-i+1, floor(window2/2)-i+1);
end
W = G;
for i = 1+floor(window2/2):size(afterpad2, 1)-floor(window2/2)
	for j = 1+floor(window2/2):size(afterpad2, 2)-floor(window2/2)
		% disp([i j])
		temp = afterpad2(i-floor(window2/2):i+floor(window2/2), j-floor(window2/2):j+floor(window2/2));
		% disp(temp)
		W(i-floor(window2/2), j-floor(window2/2)) = max(sort(reshape(temp, [1,(window2^2)])));
		% W(i-floor(window2/2), j-floor(window2/2)) = median(sort(reshape(temp, [1,(window2^2)])));
	end
end
% W = G;

window2 = 5;
b = 2;
mask = [1 4 7 4 1; 4 16 26 16 4; 7 26 41 26 7; 4 16 26 16 4; 1 4 7 4 1] / 273;
afterpad2 = zeros(int64(N)+(window2-1));
afterpad2(1+floor(window2/2):end-floor(window2/2), 1+floor(window2/2):end-floor(window2/2)) = W;
for i = 1:2
	afterpad2(i,:) = afterpad2(6-i,:);
	afterpad2(end-i+1,:) = afterpad2(end-5+i, :);
	afterpad2(:, i) = afterpad2(:, 6-i);
	afterpad2(:, end-i+1) = afterpad2(:, end-5+i);
	afterpad2(i,i) = afterpad2(6-i, 6-i);
	afterpad2(end-i+1,end-i+1) = afterpad2(end-5+i, end-5+i);
	afterpad2(i, end-i+1) = afterpad2(6-i, end-5+i);
	afterpad2(end-i+1, i) = afterpad2(end-5+i, 6-i);
end
RG = zeros(N,N);
for i = 1+floor(window2/2):size(afterpad2, 1)-floor(window2/2)
	for j = 1+floor(window2/2):size(afterpad2, 2)-floor(window2/2)
		temp = afterpad2(i-floor(window2/2):i+floor(window2/2), j-floor(window2/2):j+floor(window2/2));
		temp2 = 0;
		for k = 1:25
			temp2 = temp2 + temp(k) * mask(k);
		end
		RG(i-floor(window2/2), j-floor(window2/2)) = temp2;
		% RS(i-floor(window2/2), j-floor(window2/2)) = median(sort(reshape(temp, [1,25])));
	end
end
W = RG

imshow(W, [0,255]);
fid2=fopen('W.raw','wb');
Towrite=permute(W, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);
