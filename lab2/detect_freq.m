t = 0:1/2000:5;
x = chirp(t, 0, 5, 1000);
soundsc(x, 2000);

%%
fs = 8192;
f = 697; % This is the studied frequency
t = 0:1/fs:5;
x = sin(2*pi*t*f);
soundsc(x, fs);

%%
f = 697; % This is the studied frequency
n = 1:8192;
x = sin(2*pi*n*f / 8192);
soundsc(x);

%%
fs = 8192;
f1 = 770;
f2 = 1336;
t = 0:1/fs:5;
x = sin(2*pi*t*f1)+sin(2*pi*t*f2);
soundsc(x, fs);

%%
fs = 8192;
f1 = 852;
f2 = 1209;
t = 0:1/fs:5;
x = sin(2*pi*t*f1)+sin(2*pi*t*f2);
soundsc(x, fs);