filename = 'TrainingSet.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);            
% disp([X Y]);
trainset=zeros(450,248);
trainset(1:Size)=pixel(1:Size);
trainset=permute(trainset, [2,1]);
% imshow(trainset, [0,255]);

for i = 1:248
	for j = 1:450
		if trainset(i,j) > 100
			trainset(i,j) = 0;
		else
			trainset(i,j) = 1;
		end
	end
end
% figure;
% imshow(trainset, [0,1]);

i_list = [30,75,125,175,210];
count = 0;
train_con = zeros(248, 450);
for x = 1:length(i_list)
	i = i_list(x);
	for j = 11:440
		if trainset(i,j) == 1 && train_con(i,j) == 0
			count = count + 1;
			train_temp = train_con;
			train_con(i,j) = count;
			for k = i-10:i+10
				for l = j-10:j+10
					if trainset(k,l) == 1
						train_con(k,l) = count;
					
					else
						train_con(k,l) = 0;
					end
				end
			end
			while(~isequal(train_temp,train_con))
				train_temp = train_con;
				for k = 11:238
					for l = 11:440
						if train_temp(k,l) == count
							for x = k-10:k+10
								for y = l-10:l+10
									if trainset(x,y) == 1
										train_con(x,y) = count;
									else
										train_con(x,y) = 0;
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
% figure;
% imshow(train_con, [0,count]);
up(1:count) = 512;
down(1:count) = 1;
left(1:count) = 512;
right(1:count) = 1;
train_width = zeros(1,count);
train_height = zeros(1,count);
max_width = 0;
max_height = 0;
for c = 1:count
	for i = 1:248
		for j = 1:450
			if train_con(i,j) == c
				if i < up(c)
					up(c) = i;
				end
				if i > down(c)
					down(c) = i;
				end
				if j < left(c)
					left(c) = j;
				end
				if j > right(c)
					right(c) = j;
				end
			end
		end
	end
	train_width(c) = right(c)-left(c)+1;
	train_height(c) = down(c)-up(c)+1;
	if (right(c)-left(c)+1) > max_width
		max_width = right(c)-left(c)+1;
	end
	if (down(c)-up(c)+1) > max_height
		max_height = down(c)-up(c)+1;
	end
end
median_width = median(train_width);
median_height = median(train_height);

Characters = zeros(max_height, max_width, count);
for c = 1:count
	width_add = max_width - (right(c)-left(c)+1);
	height_add = max_height - (down(c)-up(c)+1);
	Characters(1+floor(height_add/2):floor(height_add/2)+train_height(c), 1+floor(width_add/2):floor(width_add/2)+train_width(c), c) = trainset(up(c):down(c), left(c):right(c));
	% Characters(:,:,c) = bwmorph(Characters(:,:,c),'skel',Inf);
	% name = strcat('train/Character1/',int2str(c));
	% name = strcat(name,'.jpg');
	% imwrite(Characters(:,:,c), name);
end

hvw = zeros(1, count);
for c = 1:count
	hvw(c) = train_width(c) / train_height(c);
end

Components = zeros(1, count);
for c = 1: count
	Character_con = zeros(max_height, max_width);
	temp = 0;
	for i = 2:max_height-1
		for j = 2:max_width-1
			if Characters(i,j,c) == 1 && Character_con(i,j) == 0
				temp = temp + 1;
				Character_temp = Character_con;
				Character_con(i,j) = temp;
				for x = i-1:i+1
					for y = j-1:j+1
						if Characters(x,y,c) == 1
							Character_con(x,y) = temp;
						end
					end
				end
				while(~isequal(Character_temp,Character_con))
					Character_temp = Character_con;
					for k = 2:max_height-1
						for l = 2:max_width-1
							if Character_temp(k,l) == temp
								for x = k-1:k+1
									for y = l-1:l+1
										if Characters(x,y,c) == 1
											Character_con(x,y) = temp;
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
	Components(c) = temp;
end

Q11 = [1 0; 0 0];
Q12 = [0 1; 0 0];
Q13 = [0 0; 1 0];
Q14 = [0 0; 0 1];
Q31 = [0 1; 1 1];
Q32 = [1 0; 1 1];
Q33 = [1 1; 0 1];
Q34 = [1 1; 1 0];
QD1 = [1 0; 0 1];
QD2 = [0 1; 1 0];
Eular = zeros(1, count);
for c = 1:count
	eu = 0;
	for i = -2: max_height
		for j = -2:max_width
			temp = trainset(up(c)+i:up(c)+i+1,left(c)+j:left(c)+j+1);
			if isequal(temp, Q11) || isequal(temp, Q12) || isequal(temp, Q13) || isequal(temp, Q14)
				eu = eu+1;
			end
			if isequal(temp, Q31) || isequal(temp, Q32) || isequal(temp, Q33) || isequal(temp, Q34)
				eu = eu-1;
			end
			if isequal(temp, QD1) || isequal(temp, QD2)
				en = eu-2;
			end
		end
	end
	Eular(c) = eu / 4;
end


Table = zeros(count, 10);
for i = 1:count
	for x = 1:max_width
		for y = 1:max_height
			Table(i,1) = Table(i,1) + (x.^0)*(y.^0)*Characters(y,x,i);% (0,0)
			Table(i,2) = Table(i,2) + (x.^0)*(y.^1)*Characters(y,x,i);% (0,1)
			Table(i,3) = Table(i,3) + (x.^1)*(y.^0)*Characters(y,x,i);% (1,0)
			Table(i,4) = Table(i,4) + (x.^1)*(y.^1)*Characters(y,x,i);% (1,1)
			Table(i,5) = Table(i,5) + (x.^2)*(y.^0)*Characters(y,x,i);% (2,0)
			Table(i,6) = Table(i,6) + (x.^0)*(y.^2)*Characters(y,x,i);% (0,2)
			Table(i,7) = Table(i,7) + (x.^2)*(y.^1)*Characters(y,x,i);% (2,1)
			Table(i,8) = Table(i,8) + (x.^1)*(y.^2)*Characters(y,x,i);% (1,2)
			Table(i,9) = Table(i,9) + (x.^3)*(y.^0)*Characters(y,x,i);% (3,0)
			Table(i,10) = Table(i,10) + (x.^0)*(y.^3)*Characters(y,x,i);% (0,3)
		end
	end
	Table(i,1) = Table(i,1) / ((max_width.^0)*(max_height.^0));% (0,0)
	Table(i,2) = Table(i,2) / ((max_width.^0)*(max_height.^1));% (0,1)
	Table(i,3) = Table(i,3) / ((max_width.^1)*(max_height.^0));% (1,0)
	Table(i,4) = Table(i,4) / ((max_width.^1)*(max_height.^1));% (1,1)
	Table(i,5) = Table(i,5) / ((max_width.^2)*(max_height.^0));% (2,0)
	Table(i,6) = Table(i,6) / ((max_width.^0)*(max_height.^2));% (0,2)
	Table(i,7) = Table(i,7) / ((max_width.^2)*(max_height.^1));% (2,1)
	Table(i,8) = Table(i,8) / ((max_width.^1)*(max_height.^2));% (1,2)
	Table(i,9) = Table(i,9) / ((max_width.^3)*(max_height.^0));% (3,0)
	Table(i,10) = Table(i,10) / ((max_width.^0)*(max_height.^3));% (0,3)
end

% X = zeros(count,29*17);
% for i = 1: count
% 	for y = 1: max_height
% 		for x = 1: max_width
% 			X(i, (y-1)*max_height + x) = Characters(y,x,i);
% 		end
% 	end
% end
% label = [1:count];
% tc = fitctree(Table,label);
% tc = fitctree(X,label);
% tc = TreeBagger(100,X,label);

Answer_list = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z' ...
'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' ...
'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' '!' '@' '#' '$' '%' '^' '&' '*'];
% sample1
filename = 'sample1.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
% disp([X Y]);
test1=zeros(390,125);
test1(1:Size)=pixel(1:Size);
test1=permute(test1, [2,1]);
% imshow(test1, [0,255]);

padding1 = zeros(127, 392);                                 
padding1(2:126, 2:391) = test1;
padding1(1,:) = padding1(3,:);
padding1(127,:) = padding1(125,:);
padding1(:,1) = padding1(:,3);
padding1(:,392) = padding1(:,390);
for i = 2:126
	for j = 2:391
		temp = padding1(i-1:i+1,j-1:j+1);
		test1(i-1, j-1) = median(sort(reshape(temp, [1,9])));
	end
end
% imshow(test1, [0,255]);

for i = 1:125
	for j = 1:390
		if test1(i,j) > 100
			test1(i,j) = 0;
		else
			test1(i,j) = 1;
		end
	end
end
% imshow(test1, [0, 1]);

count1 = 0;
test1_con = zeros(125, 390);
for j = 11:380
	for i = 11:115
		if test1(i,j) == 1 && test1_con(i,j) == 0
			count1 = count1 + 1;
			test1_temp = test1_con;
			test1_con(i,j) = count1;
			for k = i-10:i+10
				for l = j-10:j+10
					if test1(k,l) == 1
						test1_con(k,l) = count1;
					
					else
						test1_con(k,l) = 0;
					end
				end
			end
			while(~isequal(test1_temp,test1_con))
				test1_temp = test1_con;
				for k = 11:115
					for l = 11:380
						if test1_temp(k,l) == count1
							for x = k-10:k+10
								for y = l-10:l+10
									if test1(x,y) == 1
										test1_con(x,y) = count1;
									else
										test1_con(x,y) = 0;
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
% imshow(test1_con, [0,count1]);
max_width = 17;
max_height = 29;
up1(1:count1) = 512;
down1(1:count1) = 1;
left1(1:count1) = 512;
right1(1:count1) = 1;
test1_width = zeros(1,count1);
test1_height = zeros(1,count1);
for c = 1:count1
	for i = 1:125
		for j = 1:390
			if test1_con(i,j) == c
				if i < up1(c)
					up1(c) = i;
				end
				if i > down1(c)
					down1(c) = i;
				end
				if j < left1(c)
					left1(c) = j;
				end
				if j > right1(c)
					right1(c) = j;
				end
			end
		end
	end
	test1_width(c) = right1(c)-left1(c)+1;
	test1_height(c) = down1(c)-up1(c)+1;
end
Candidates1 = zeros(max_height, max_width, count1);
for c = 1:count1
	temp = test1(up1(c):down1(c), left1(c):right1(c));
	if test1_width(c) > max_width || test1_height(c) > max_height
		scale_ratio = min(max_width/test1_width(c), max_height/test1_height(c));
		ratio = [scale_ratio scale_ratio];
		oldsize = size(temp);
		newsize = max(floor(ratio.*oldsize(1:2)),1);
		rowindex = min(round(((1:newsize(1))-0.5)./ratio(1)+0.5),oldsize(1));
		colindex = min(round(((1:newsize(2))-0.5)./ratio(2)+0.5),oldsize(2));
		temp2 = temp(rowindex,colindex,:);
		if newsize(1) < max_height || newsize(2) < max_width
			width_add = max_width - newsize(2);
			height_add = max_height - newsize(1);
			Candidates1(1+floor(height_add/2):floor(height_add/2)+newsize(1), 1+floor(width_add/2):floor(width_add/2)+newsize(2), c) = temp2;
		else
			Candidates1(:,:,c) = temp2;
		end
	else
		if test1_width(c) < max_width && test1_height(c) < max_height
			if max(max_width/test1_width(c), max_height/test1_height(c)) > 1.3
				scale_ratio = max(test1_width(c)/max_width, test1_height(c)/max_height);
				ratio = [scale_ratio scale_ratio];
				oldsize = size(temp);
				newsize = max(floor(ratio.*oldsize(1:2)),1);
				rowindex = min(round(((1:newsize(1))-0.5)./ratio(1)+0.5),oldsize(1));
				colindex = min(round(((1:newsize(2))-0.5)./ratio(2)+0.5),oldsize(2));
				temp2 = temp(rowindex,colindex,:);
				if newsize(1) < max_height || newsize(2) < max_width
					width_add = max_width - newsize(2);
					height_add = max_height - newsize(1);
					Candidates1(1+floor(height_add/2):floor(height_add/2)+newsize(1), 1+floor(width_add/2):floor(width_add/2)+newsize(2), c) = temp2;
				else
					Candidates1(:,:,c) = temp2;
				end
			else
				width_add = max_width - test1_width(c);
				height_add = max_height - test1_height(c);
				Candidates1(1+floor(height_add/2):floor(height_add/2)+test1_height(c), 1+floor(width_add/2):floor(width_add/2)+test1_width(c), c) = temp;
			end
		end
	end
	% Candidates1(:,:,c) = bwmorph(Candidates1(:,:,c),'skel',Inf);
	% name = strcat('test1/character1/', int2str(c));
	% name = strcat(name,'.jpg');
	% imwrite(Candidates1(:,:,c), name);
end

test1_table = zeros(count1, 10);
for i = 1:count1
	for x = 1:max_width
		for y = 1:max_height
			test1_table(i,1) = test1_table(i,1) + (x.^0)*(y.^0)*Candidates1(y,x,i);% (0,0)
			test1_table(i,2) = test1_table(i,2) + (x.^0)*(y.^1)*Candidates1(y,x,i);% (0,1)
			test1_table(i,3) = test1_table(i,3) + (x.^1)*(y.^0)*Candidates1(y,x,i);% (1,0)
			test1_table(i,4) = test1_table(i,4) + (x.^1)*(y.^1)*Candidates1(y,x,i);% (1,1)
			test1_table(i,5) = test1_table(i,5) + (x.^2)*(y.^0)*Candidates1(y,x,i);% (2,0)
			test1_table(i,6) = test1_table(i,6) + (x.^0)*(y.^2)*Candidates1(y,x,i);% (0,2)
			test1_table(i,7) = test1_table(i,7) + (x.^2)*(y.^1)*Candidates1(y,x,i);% (2,1)
			test1_table(i,8) = test1_table(i,8) + (x.^1)*(y.^2)*Candidates1(y,x,i);% (1,2)
			test1_table(i,9) = test1_table(i,9) + (x.^3)*(y.^0)*Candidates1(y,x,i);% (3,0)
			test1_table(i,10) = test1_table(i,10) + (x.^0)*(y.^3)*Candidates1(y,x,i);% (0,3)
		end
	end
	test1_table(i,1) = test1_table(i,1) / ((max_width.^0)*(max_height.^0));% (0,0)
	test1_table(i,2) = test1_table(i,2) / ((max_width.^0)*(max_height.^1));% (0,1)
	test1_table(i,3) = test1_table(i,3) / ((max_width.^1)*(max_height.^0));% (1,0)
	test1_table(i,4) = test1_table(i,4) / ((max_width.^1)*(max_height.^1));% (1,1)
	test1_table(i,5) = test1_table(i,5) / ((max_width.^2)*(max_height.^0));% (2,0)
	test1_table(i,6) = test1_table(i,6) / ((max_width.^0)*(max_height.^2));% (0,2)
	test1_table(i,7) = test1_table(i,7) / ((max_width.^2)*(max_height.^1));% (2,1)
	test1_table(i,8) = test1_table(i,8) / ((max_width.^1)*(max_height.^2));% (1,2)
	test1_table(i,9) = test1_table(i,9) / ((max_width.^3)*(max_height.^0));% (3,0)
	test1_table(i,10) = test1_table(i,10) / ((max_width.^0)*(max_height.^3));% (0,3)
end

% Answer1 = zeros(1, count1);
% for i = 1:count1
% 	min_temp = 1000000;
% 	min_answer = 0;
% 	for x = 1:count
% 		temp = 0;
% 		for y = 1:10
% 			temp = temp + (test1_table(i,y) - Table(x,y)).^2;
% 		end
% 		if temp < min_temp
% 			min_temp = temp;
% 			min_answer = x;
% 		end
% 	end
% 	Answer1(i) = min_answer;
% end
% disp(ans1);

% sample2
filename = 'sample2.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
% disp([X Y]);
test2=zeros(390,125);
test2(1:Size)=pixel(1:Size);
test2=permute(test2, [2,1]);
%imshow(test2, [0,255]);

padding2 = zeros(127, 392);                                                 
padding2(2:126, 2:391) = test2;
padding2(1,:) = padding2(3,:);
padding2(127,:) = padding2(125,:);
padding2(:,1) = padding2(:,3);
padding2(:,392) = padding2(:,390);
for i = 2:126
	for j = 2:391
		temp = padding2(i-1:i+1,j-1:j+1);
		test2(i-1, j-1) = median(sort(reshape(temp, [1,9])));
	end
end
%imshow(test2, [0,255]);
for i = 1:125
	for j = 1:390
		if test2(i,j) > 100
			test2(i,j) = 0;
		else
			test2(i,j) = 1;
		end
	end
end
% figure;
%imshow(test2, [0, 1]);
count2 = 0;
test2_con = zeros(125, 390);
for j = 11:380
	for i = 11:115
		if test2(i,j) == 1 && test2_con(i,j) == 0
			count2 = count2 + 1;
			test2_temp = test2_con;
			test2_con(i,j) = count2;
			for k = i-10:i+10
				for l = j-10:j+10
					if test2(k,l) == 1
						test2_con(k,l) = count2;
					
					else
						test2_con(k,l) = 0;
					end
				end
			end
			while(~isequal(test2_temp,test2_con))
				test2_temp = test2_con;
				for k = 11:115
					for l = 11:380
						if test2_temp(k,l) == count2
							for x = k-10:k+10
								for y = l-10:l+10
									if test2(x,y) == 1
										test2_con(x,y) = count2;
									else
										test2_con(x,y) = 0;
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
% figure;
% imshow(test2_con, [0,count2]);
up2(1:count2) = 512;
down2(1:count2) = 1;
left2(1:count2) = 512;
right2(1:count2) = 1;
test2_width = zeros(1,count2);
test2_height = zeros(1,count2);
for c = 1:count2
	for i = 1:125
		for j = 1:390
			if test2_con(i,j) == c
				if i < up2(c)
					up2(c) = i;
				end
				if i > down2(c)
					down2(c) = i;
				end
				if j < left2(c)
					left2(c) = j;
				end
				if j > right2(c)
					right2(c) = j;
				end
			end
		end
	end
	test2_width(c) = right2(c)-left2(c)+1;
	test2_height(c) = down2(c)-up2(c)+1;
end
Candidates2 = zeros(max_height, max_width, count2);
for c = 1:count2
	temp = test2(up2(c):down2(c), left2(c):right2(c));
	if test2_width(c) > max_width || test2_height(c) > max_height
		scale_ratio = min(max_width/test2_width(c), max_height/test2_height(c));
		ratio = [scale_ratio scale_ratio];
		oldsize = size(temp);
		newsize = max(floor(ratio.*oldsize(1:2)),1);
		rowindex = min(round(((1:newsize(1))-0.5)./ratio(1)+0.5),oldsize(1));
		colindex = min(round(((1:newsize(2))-0.5)./ratio(2)+0.5),oldsize(2));
		temp2 = temp(rowindex,colindex,:);
		if newsize(1) < max_height || newsize(2) < max_width
			width_add = max_width - newsize(2);
			height_add = max_height - newsize(1);
			Candidates2(1+floor(height_add/2):floor(height_add/2)+newsize(1), 1+floor(width_add/2):floor(width_add/2)+newsize(2), c) = temp2;
		else
			Candidates2(:,:,c) = temp2;
		end
	else
		if test2_width(c) < max_width && test2_height(c) < max_height
			if max(max_width/test2_width(c), max_height/test2_height(c)) > 1.3
				scale_ratio = max(test2_width(c)/max_width, test2_height(c)/max_height);
				ratio = [scale_ratio scale_ratio];
				oldsize = size(temp);
				newsize = max(floor(ratio.*oldsize(1:2)),1);
				rowindex = min(round(((1:newsize(1))-0.5)./ratio(1)+0.5),oldsize(1));
				colindex = min(round(((1:newsize(2))-0.5)./ratio(2)+0.5),oldsize(2));
				temp2 = temp(rowindex,colindex,:);
				if newsize(1) < max_height || newsize(2) < max_width
					width_add = max_width - newsize(2);
					height_add = max_height - newsize(1);
					Candidates2(1+floor(height_add/2):floor(height_add/2)+newsize(1), 1+floor(width_add/2):floor(width_add/2)+newsize(2), c) = temp2;
				else
					Candidates2(:,:,c) = temp2;
				end
			else
				width_add = max_width - test2_width(c);
				height_add = max_height - test2_height(c);
				Candidates2(1+floor(height_add/2):floor(height_add/2)+test2_height(c), 1+floor(width_add/2):floor(width_add/2)+test2_width(c), c) = temp;
			end
		end
	end
	% Candidates2(:,:,c) = bwmorph(Candidates2(:,:,c),'skel',Inf);
	% name = strcat('test2/character/', int2str(c));
	% name = strcat(name,'.jpg');
	% imwrite(Candidates2(:,:,c), name);
end

test2_table = zeros(count2, 10);
for i = 1:count2
	for x = 1:max_width
		for y = 1:max_height
			test2_table(i,1) = test2_table(i,1) + (x.^0)*(y.^0)*Candidates2(y,x,i);% (0,0)
			test2_table(i,2) = test2_table(i,2) + (x.^0)*(y.^1)*Candidates2(y,x,i);% (0,1)
			test2_table(i,3) = test2_table(i,3) + (x.^1)*(y.^0)*Candidates2(y,x,i);% (1,0)
			test2_table(i,4) = test2_table(i,4) + (x.^1)*(y.^1)*Candidates2(y,x,i);% (1,1)
			test2_table(i,5) = test2_table(i,5) + (x.^2)*(y.^0)*Candidates2(y,x,i);% (2,0)
			test2_table(i,6) = test2_table(i,6) + (x.^0)*(y.^2)*Candidates2(y,x,i);% (0,2)
			test2_table(i,7) = test2_table(i,7) + (x.^2)*(y.^1)*Candidates2(y,x,i);% (2,1)
			test2_table(i,8) = test2_table(i,8) + (x.^1)*(y.^2)*Candidates2(y,x,i);% (1,2)
			test2_table(i,9) = test2_table(i,9) + (x.^3)*(y.^0)*Candidates2(y,x,i);% (3,0)
			test2_table(i,10) = test2_table(i,10) + (x.^0)*(y.^3)*Candidates2(y,x,i);% (0,3)
		end
	end
	test2_table(i,1) = test2_table(i,1) / ((max_width.^0)*(max_height.^0));% (0,0)
	test2_table(i,2) = test2_table(i,2) / ((max_width.^0)*(max_height.^1));% (0,1)
	test2_table(i,3) = test2_table(i,3) / ((max_width.^1)*(max_height.^0));% (1,0)
	test2_table(i,4) = test2_table(i,4) / ((max_width.^1)*(max_height.^1));% (1,1)
	test2_table(i,5) = test2_table(i,5) / ((max_width.^2)*(max_height.^0));% (2,0)
	test2_table(i,6) = test2_table(i,6) / ((max_width.^0)*(max_height.^2));% (0,2)
	test2_table(i,7) = test2_table(i,7) / ((max_width.^2)*(max_height.^1));% (2,1)
	test2_table(i,8) = test2_table(i,8) / ((max_width.^1)*(max_height.^2));% (1,2)
	test2_table(i,9) = test2_table(i,9) / ((max_width.^3)*(max_height.^0));% (3,0)
	test2_table(i,10) = test2_table(i,10) / ((max_width.^0)*(max_height.^3));% (0,3)
end

% X1 = zeros(count1,29*17);
% for i = 1: count1
% 	for y = 1: max_height
% 		for x = 1: max_width
% 			X1(i, (y-1)*max_height + x) = Candidates1(y,x,i);
% 		end
% 	end
% end

% X2 = zeros(count2,29*17);
% for i = 1: count2
% 	for y = 1: max_height
% 		for x = 1: max_width
% 			X2(i, (y-1)*max_height + x) = Candidates2(y,x,i);
% 		end
% 	end
% end

label1 = zeros(1, count1);
label2 = zeros(1, count2);
% label1 = predict(tc, test1_table);
% label2 = predict(tc, test2_table);
% label1 = predict(tc, X1);
% label2 = predict(tc, X2);
% label1 = cellfun(@str2num,label1);
% label2 = cellfun(@str2num,label2);
hvw1 = zeros(1, count1);
for c = 1:count1
	hvw1(c) = test1_width(c) / test1_height(c);
end
hvw2 = zeros(1, count2);
for c = 1:count2
	hvw2(c) = test2_width(c) / test2_height(c);
end

Q11 = [1 0; 0 0];
Q12 = [0 1; 0 0];
Q13 = [0 0; 1 0];
Q14 = [0 0; 0 1];
Q31 = [0 1; 1 1];
Q32 = [1 0; 1 1];
Q33 = [1 1; 0 1];
Q34 = [1 1; 1 0];
QD1 = [1 0; 0 1];
QD2 = [0 1; 1 0];
Eular1 = zeros(1, count1);
for c = 1:count1
	eu = 0;
	for i = -2: max_height
		for j = -2:max_width
			temp = test1(up1(c)+i:up1(c)+i+1,left1(c)+j:left1(c)+j+1);
			if isequal(temp, Q11) || isequal(temp, Q12) || isequal(temp, Q13) || isequal(temp, Q14)
				eu = eu+1;
			end
			if isequal(temp, Q31) || isequal(temp, Q32) || isequal(temp, Q33) || isequal(temp, Q34)
				eu = eu-1;
			end
			if isequal(temp, QD1) || isequal(temp, QD2)
				en = eu-2;
			end
		end
	end
	Eular1(c) = eu / 4;
end
Eular2 = zeros(1, count2);
for c = 1:count2
	eu = 0;
	for i = -2: max_height
		for j = -2:max_width
			temp = test2(up2(c)+i:up2(c)+i+1,left2(c)+j:left2(c)+j+1);
			if isequal(temp, Q11) || isequal(temp, Q12) || isequal(temp, Q13) || isequal(temp, Q14)
				eu = eu+1;
			end
			if isequal(temp, Q31) || isequal(temp, Q32) || isequal(temp, Q33) || isequal(temp, Q34)
				eu = eu-1;
			end
			if isequal(temp, QD1) || isequal(temp, QD2)
				en = eu-2;
			end
		end
	end
	Eular2(c) = eu / 4;
end
for i = 1:count1
	max_index = 0;
	max_value = 0;
	for j = 1:count
		% if abs(hvw1(i) - hvw(j)) > 0.2
		% 	continue;
		% end
		% if Eular1(i) ~= Eular(j)
		% 	continue
		% end
		temp_value = 0;
		for y = 1:29
			for x = 1:17
				if Candidates1(y,x,i) == 1
					if Candidates1(y,x,i) == Characters(y,x,j)
						temp_value = temp_value + 1;
					end
				end
				% if Candidates1(y,x,i) == 0
				% 	if Candidates1(y,x,i) == Characters(y,x,j)
				% 		temp_value = temp_value + 0.2;
				% 	end
				% end
				% if Candidates1(y,x,i) == 0 && Characters(y,x,j) == 1
				% 	temp_value = temp_value + 0.2;
				% end
				% if Candidates1(y,x,i) == 1 && Characters(y,x,j) == 0
				% 	temp_value = temp_value + 0.2;
				% end
			end
		end
		if temp_value > max_value
			max_value = temp_value;
			max_index = j;
		end
	end
	label1(i) = max_index;
end

for i = 1:count2
	max_index = 0;
	max_value = 0;
	for j = 1:count
		% if abs(hvw2(i) - hvw(j)) > 0.2
		% 	continue;
		% end
		% if Eular2(i) ~= Eular(j)
		% 	continue
		% end
		temp_value = 0;
		for y = 1:29
			for x = 1:17
				if Candidates2(y,x,i) == 1
					if Candidates2(y,x,i) == Characters(y,x,j)
						temp_value = temp_value + 1;
					end
				end
				% if Candidates2(y,x,i) == 0
				% 	if Candidates2(y,x,i) == Characters(y,x,j)
				% 		temp_value = temp_value + 0.2;
				% 	end
				% end
				% if Candidates2(y,x,i) == 0 && Characters(y,x,j) == 1
				% 	temp_value = temp_value + 0.2;
				% end
				% if Candidates2(y,x,i) == 1 && Characters(y,x,j) == 0
				% 	temp_value = temp_value + 0.2;
				% end
			end
		end
		if temp_value > max_value
			max_value = temp_value;
			max_index = j;
		end
	end
	label2(i) = max_index;
end


ans1 = Answer_list(label1(1));
for i = 2:count1
	ans1 = strcat(ans1, Answer_list(label1(i)));
end
disp('Sample1:');
disp(ans1);

ans2 = Answer_list(label2(1));
for i = 2:count2
	ans2 = strcat(ans2, Answer_list(label2(i)));
end
disp('Sample2:');
disp(ans2);

acc_count = 0;
ans1 = [8 35 33 50 61];
ans2 = [19 2 57 20 60 9];
for i = 1:5
	if label1(i) == ans1(i)
		acc_count = acc_count + 1;
	end
end
for i = 1:6
	if label2(i) == ans2(i)
		acc_count = acc_count + 1;
	end
end
disp('Accuracy=');
disp(acc_count / 11);