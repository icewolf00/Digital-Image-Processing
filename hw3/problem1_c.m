filename = 'sample1.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
F=zeros(N,N);
F(1:Size)=pixel(1:Size);
F=permute(F, [2,1]);
G = zeros(N,N);
mask = [50,26,152,176,308,23,89,464,55,310,31,91,217,472,496,436,311,95,473,500,438,63,219,504,439,502,127,319,223,475,505,508,503,383,479,509,447,255,507,510];
haha = size(mask);
mask_len = haha(2);
mask1_array = zeros(1,512);
for i = 1:mask_len
	mask1_array(mask(i)) = 1;
end

M = zeros(N,N);

for i = 2:N-1
	for j = 2:N-1
		temp = F(i-1:i+1, j-1:j+1);
		answer = 0;
		count = 1;
		for k = 1:9
			answer = answer + (temp(k) / 255) * count;
			count = count * 2;
		end
		if answer == 0
			continue;
		end
		if mask1_array(answer) == 1
			M(i,j) = 1;
		end
	end
end

% imshow(M, [0,1]);
G = F;
% imshow(G, [0,255]);
for i = 2:N-1
	for j = 2:N-1
		temp = M(i-1:i+1, j-1:j+1);
		mask = [0 0 0 0 1 0 0 0 1]; %spur
		if isequal(temp,mask)
			continue;
		end
		mask = [0 0 0 0 1 0 1 0 0];
		if isequal(temp,mask)
			continue;
		end
		mask = [0 0 1 0 1 0 0 0 0];
		if isequal(temp,mask)
			continue;
		end
		mask = [1 0 0 0 1 0 0 0 0];
		if isequal(temp,mask)
			continue;
		end
		mask = [0 0 0 0 1 0 0 1 0];%Single 4-connection
		if isequal(temp,mask)
			continue;
		end
		mask = [0 0 0 0 1 1 0 0 0];
		if isequal(temp,mask)
			continue;
		end
		mask = [0 0 0 1 1 0 0 0 0];
		if isequal(temp,mask)
			continue;
		end
		mask = [0 1 0 0 1 0 0 0 0];
		if isequal(temp,mask)
			continue;
		end
		mask = [0 1 0 0 1 1 0 0 0];%L corner
		if isequal(temp,mask)
			continue;
		end
		mask = [0 1 0 1 1 0 0 0 0];
		if isequal(temp,mask)
			continue;
		end
		mask = [0 0 0 0 1 1 0 1 0];
		if isequal(temp,mask)
			continue;
		end
		mask = [0 0 0 1 1 0 0 1 0];
		if isequal(temp,mask)
			continue;
		end
		%Corner cluster
		if temp(2)==1 && temp(3)==1 && temp(5)==1 && temp(6)==1
			continue
		end
		if temp(4)==1 && temp(5)==1 && temp(7)==1 && temp(8)==1
			continue
		end
		if temp(1)==1 && temp(1)==1 && temp(4)==1 && temp(5)==1
			continue
		end
		if temp(5)==1 && temp(6)==1 && temp(8)==1 && temp(9)==1
			continue
		end
		%Tee branch
		if temp(2)==1 && temp(4)==1 && temp(5)==1 && temp(6)==1 && temp(8)==0 && temp(9)==0
			continue
		end
		if temp(2)==1 && temp(4)==1 && temp(5)==1 && temp(8)==1
			continue
		end
		if temp(4)==1 && temp(5)==1 && temp(6)==1 && temp(8)==1
			continue
		end
		if temp(2)==1 && temp(5)==1 && temp(6)==1 && temp(8)==1
			continue
		end
		%Vee branch
		if temp(1)==1 && temp(3)==1 && temp(5)==1 && (temp(7)==1 || temp(8)==1 || temp(9)==1)
			continue
		end
		if temp(1)==1 && temp(5)==1 && temp(7)==1 && (temp(3)==1 || temp(6)==1 || temp(9)==1)
			continue
		end
		if temp(5)==1 && temp(7)==1 && temp(9)==1 && (temp(1)==1 || temp(2)==1 || temp(3)==1)
			continue
		end
		if temp(3)==1 && temp(5)==1 && temp(9)==1 && (temp(1)==1 || temp(4)==1 || temp(7)==1)
			continue
		end
		%Digonal branch
		if temp(2)==1 && temp(5)==1 && temp(6)==1 && temp(7)==1 && temp(3)==0 && temp(4)==0 && temp(8)==0
			continue
		end
		if temp(2)==1 && temp(4)==1 && temp(5)==1 && temp(9)==1 && temp(1)==0 && temp(6)==0 && temp(8)==0
			continue
		end
		if temp(3)==1 && temp(4)==1 && temp(5)==1 && temp(8)==1 && temp(2)==0 && temp(6)==0 && temp(7)==0
			continue
		end
		if temp(1)==1 && temp(5)==1 && temp(6)==1 && temp(8)==1 && temp(2)==0 && temp(4)==0 && temp(9)==0
			continue
		end
		if M(i,j) == 0
			continue
		end
		G(i,j) = 0;
	end
end
% figure;
% imshow(G, [0,255]);

while(~isequal(G,F))
	F = G;
	mask = [50,26,152,176,308,23,89,464,55,310,31,91,217,472,496,436,311,95,473,500,438,63,219,504,439,502,127,319,223,475,505,508,503,383,479,509,447,255,507,510];
	haha = size(mask);
	mask_len = haha(2);
	mask1_array = zeros(1,512);
	for i = 1:mask_len
		mask1_array(mask(i)) = 1;
	end

	M = zeros(N,N);

	for i = 2:N-1
		for j = 2:N-1
			temp = F(i-1:i+1, j-1:j+1);
			answer = 0;
			count = 1;
			for k = 1:9
				answer = answer + (temp(k) / 255) * count;
				count = count * 2;
			end
			if answer == 0
				continue;
			end
			if mask1_array(answer) == 1
				M(i,j) = 1;
			end
		end
	end

	% imshow(M, [0,1]);
	% G = F;
	% imshow(G, [0,255]);
	for i = 2:N-1
		for j = 2:N-1
			temp = M(i-1:i+1, j-1:j+1);
			mask = [0 0 0 0 1 0 0 0 1]; %spur
			if isequal(temp,mask)
				continue;
			end
			mask = [0 0 0 0 1 0 1 0 0];
			if isequal(temp,mask)
				continue;
			end
			mask = [0 0 1 0 1 0 0 0 0];
			if isequal(temp,mask)
				continue;
			end
			mask = [1 0 0 0 1 0 0 0 0];
			if isequal(temp,mask)
				continue;
			end
			mask = [0 0 0 0 1 0 0 1 0];%Single 4-connection
			if isequal(temp,mask)
				continue;
			end
			mask = [0 0 0 0 1 1 0 0 0];
			if isequal(temp,mask)
				continue;
			end
			mask = [0 0 0 1 1 0 0 0 0];
			if isequal(temp,mask)
				continue;
			end
			mask = [0 1 0 0 1 0 0 0 0];
			if isequal(temp,mask)
				continue;
			end
			mask = [0 1 0 0 1 1 0 0 0];%L corner
			if isequal(temp,mask)
				continue;
			end
			mask = [0 1 0 1 1 0 0 0 0];
			if isequal(temp,mask)
				continue;
			end
			mask = [0 0 0 0 1 1 0 1 0];
			if isequal(temp,mask)
				continue;
			end
			mask = [0 0 0 1 1 0 0 1 0];
			if isequal(temp,mask)
				continue;
			end
			%Corner cluster
			if temp(2)==1 && temp(3)==1 && temp(5)==1 && temp(6)==1
				continue
			end
			if temp(4)==1 && temp(5)==1 && temp(7)==1 && temp(8)==1
				continue
			end
			if temp(1)==1 && temp(1)==1 && temp(4)==1 && temp(5)==1
				continue
			end
			if temp(5)==1 && temp(6)==1 && temp(8)==1 && temp(9)==1
				continue
			end
			%Tee branch
			if temp(2)==1 && temp(4)==1 && temp(5)==1 && temp(6)==1 && temp(8)==0 && temp(9)==0
				continue
			end
			if temp(2)==1 && temp(4)==1 && temp(5)==1 && temp(8)==1
				continue
			end
			if temp(4)==1 && temp(5)==1 && temp(6)==1 && temp(8)==1
				continue
			end
			if temp(2)==1 && temp(5)==1 && temp(6)==1 && temp(8)==1
				continue
			end
			%Vee branch
			if temp(1)==1 && temp(3)==1 && temp(5)==1 && (temp(7)==1 || temp(8)==1 || temp(9)==1)
				continue
			end
			if temp(1)==1 && temp(5)==1 && temp(7)==1 && (temp(3)==1 || temp(6)==1 || temp(9)==1)
				continue
			end
			if temp(5)==1 && temp(7)==1 && temp(9)==1 && (temp(1)==1 || temp(2)==1 || temp(3)==1)
				continue
			end
			if temp(3)==1 && temp(5)==1 && temp(9)==1 && (temp(1)==1 || temp(4)==1 || temp(7)==1)
				continue
			end
			%Digonal branch
			if temp(2)==1 && temp(5)==1 && temp(6)==1 && temp(7)==1 && temp(3)==0 && temp(4)==0 && temp(8)==0
				continue
			end
			if temp(2)==1 && temp(4)==1 && temp(5)==1 && temp(9)==1 && temp(1)==0 && temp(6)==0 && temp(8)==0
				continue
			end
			if temp(3)==1 && temp(4)==1 && temp(5)==1 && temp(8)==1 && temp(2)==0 && temp(6)==0 && temp(7)==0
				continue
			end
			if temp(1)==1 && temp(5)==1 && temp(6)==1 && temp(8)==1 && temp(2)==0 && temp(4)==0 && temp(9)==0
				continue
			end
			if M(i,j) == 0
				continue
			end
			G(i,j) = 0;
		end
	end
	% figure;
	% imshow(G, [0,255]);
end
% imshow(G, [0,255]);

fid2=fopen('S.raw','wb');
Towrite=permute(G, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);