filename='D.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G=zeros(N,N);
G(1:Size)=pixel(1:Size);
G=permute(G, [2,1]);

% imshow(G, [0,255])
[count,bin] = hist(G(:), 0:255);

window = 51;
afterpad = zeros(int64(N)+(window-1));
afterpad(1+floor(window/2):end-floor(window/2), 1+floor(window/2):end-floor(window/2)) = G;
L = zeros(N, N);

for i = 1+floor(window/2):size(afterpad, 1)-floor(window/2)
	% disp(i);
	for j = 1+floor(window/2):size(afterpad, 2)-floor(window/2)
		temp=zeros(window);
		temp = afterpad(i-floor(window/2):i+floor(window/2), j-floor(window/2):j+floor(window/2));
		[count, bin] = hist(temp(:), 0:255);
		cdf=zeros(1, 256);
		for pixel = 1:256
			if pixel == 1
				cdf(pixel)=count(pixel);
			else
				cdf(pixel)=cdf(pixel-1)+count(pixel);
			end
		end
		L(i-floor(window/2), j-floor(window/2)) = 255*cdf(afterpad(i, j)+1)/(window*window);
	end
end
imshow(L, [0,255]);


fid2=fopen('L.raw','wb');
Towrite=permute(L, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);
