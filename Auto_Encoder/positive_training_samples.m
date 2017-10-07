%% Êµ¾°ÕÕÆ¬'C:\Users\¼Ñç÷\Downloads\²É¼¯Í¼Ïñ\'
%%left01-left37     0001-0037
%%left114-left144   0038-0068
%%left173-left218   0069-0114
%%left352-left387   0115-0150

%% ÇŞÊÒÕÕÆ¬'D:\Ñ¸À×ÏÂÔØ\ph\'
%%0001-0200         0151-0350

%% ÊÒÄÚÕÕÆ¬
%%0201-0400         0351-0550
%%0550-0599         0551-0600

%% ³ÌĞò
path='D:\Ñ¸À×ÏÂÔØ\ph\';
formatSpec1='%04d.jpg';
formatSpec2='%04d.jpg';
for i=760
    imagename=sprintf(formatSpec1,i+311);
    filepath=[path imagename];
    filename=sprintf(formatSpec2,i);
    test_h(filepath,filename);
end
