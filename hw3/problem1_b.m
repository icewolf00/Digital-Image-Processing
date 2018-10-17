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

count = 0;
G_connected = zeros(N, N);
for i = 2:N-1
	for j = 2:N-1
		if G(i,j) == 255 && G_connected(i,j) == 0
			count = count + 1;
			G_temp = G_connected;
			G_connected(i,j) = count;
			for k = i-1:i+1
				for l = j-1:j+1
					if G(k,l) == 255
						G_connected(k,l) = count;
					
					else
						G_connected(k,l) = 0;
					end
				end
			end
			while(~isequal(G_temp,G_connected))
				G_temp = G_connected;
				for k = 2:N-1
					for l = 2:N-1
						if G_temp(k,l) == count
							for x = k-1:k+1
								for y = l-1:l+1
									if G(x,y) == 255
										G_connected(x,y) = count;
									else
										G_connected(x,y) = 0;
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
disp('count=');
disp(count);
% figure;
% imshow(G_connected, [0,8]);