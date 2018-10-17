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
cdf=zeros(1, 256);
for i = 1:256
	if i == 1
		cdf(i)=count(i);
	else
		cdf(i)=cdf(i-1)+count(i);
	end
end
disp(cdf);
after=zeros(1, 256);
for i = 1:256
	after(i)=(255/(X*Y))*cdf(i);
end
H=zeros(N,N);
for i = 1:256
	H(find(G==i-1))=after(i);
end
imshow(H, [0,255]);

% [count,bin] = hist(H(:), 0:255);
% stem(bin,count, 'Marker','none');

fid2=fopen('H.raw','wb');
Towrite=permute(H, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);
