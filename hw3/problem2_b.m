filename = 'sample2.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G=zeros(N,N);
G(1:Size)=pixel(1:Size);
G=permute(G, [2,1]);

texture1 = G(1:65, 1:105);
G_fill1 = zeros(N,N);
for i = 1:N
	for j = 1:N
		if mod(i,65) == 0
			if mod(j, 105) == 0
				G_fill1(i, j) = texture1(65,105);
				continue;
			end
			G_fill1(i, j) = texture1(65,mod(j,105));
			continue;
		end
		if mod(j, 105) == 0
			G_fill1(i,j) = texture1(mod(i,65), 105);
			continue;
		end
		G_fill1(i,j) = texture1(mod(i,65), mod(j,105));
	end
end
texture2 = G(320:512, 320:512);
G_fill2 = zeros(N,N);
for i = 1:N
	for j = 1:N
		if mod(i, 192) == 0
			if mod(j, 192) == 0
				G_fill2(i, j) = texture2(192,192);
				continue;
			end
			G_fill2(i, j) = texture2(192,mod(j,192));
			continue;
		end
		if mod(j, 192) == 0
			G_fill2(i,j) = texture2(mod(i,192), 192);
			continue;
		end
		G_fill2(i,j) = texture2(mod(i,192), mod(j,192));
	end
end
texture3 = G(19:199, 332:512);
G_fill3 = zeros(N,N);
for i = 1:N
	for j = 1:N
		if mod(i, 181) == 0
			if mod(j, 181) == 0
				G_fill3(i, j) = texture3(181,181);
				continue;
			end
			G_fill3(i, j) = texture3(181,mod(j,181));
			continue;
		end
		if mod(j, 181) == 0
			G_fill3(i,j) = texture3(mod(i,181), 181);
			continue;
		end
		G_fill3(i,j) = texture3(mod(i,181), mod(j,181));
	end
end
% figure;
% imshow(G_fill1, [0,255]);
% figure;
% imshow(G_fill2, [0,255]);
% figure;
% imshow(G_fill3, [0,255]);

filename = 'K.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
K=zeros(N,N);
K(1:Size)=pixel(1:Size);
K=permute(K, [2,1]);

G_out = zeros(N,N);
for i = 1:N
	for j = 1:N
		if K(i,j) == 1
			G_out(i,j) = G_fill2(i,j);
		end
		if K(i,j) == 2
			G_out(i,j) = G_fill3(i,j);
		end
		if K(i,j) == 3
			G_out(i,j) = G_fill1(i,j);
		end
	end
end
% figure;
% imshow(G_out, [0,255]);
fid2=fopen('2b.raw','wb');
Towrite=permute(G_out, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);