filename = 'sample1.raw';
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
G_origin = G;

G_temp = zeros(N,N);
for i=2:N-1
	for j=2:N-1
		if G(i, j) == 255
			if G(i+1, j) == 255 && G(i-1, j) == 255 && G(i, j+1) == 255 && G(i,j-1) == 255
				G_temp(i, j) = 255;
			end
			% temp = G(i-1:i+1, j-1:j+1);
			% if sum(sum(temp)) == 255*9
			% 	G_temp(i,j) = 255;
			% end
		end
	end
end

G_out = G - G_temp;
% figure;
% imshow(G_out, [0,255]);
fid2=fopen('B.raw','wb');
Towrite=permute(G_out, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);