% Title: High Pass Filter
% Aim: Design High Pass Filter using FDATOOL
% Programmer name: Ashish Ashok Gopal, 1702005, FY MTech
% Department: Department of Electronics Engineering
% Mentor: Dr. Nirmal, HOD
% Department: Department of Electronics Engineering
% Date: 28/09/2017

% ***************Program starts here*************************

function Hd = Filters_HPF
% Butterworth Lowpass filter designed using FDESIGN.LOWPASS.

% Reading .wav file
[x, Fs]=audioread('Lion.wav');

N  = 5;     % Order
Fc = 5000;  % Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.highpass('N,F3dB', N, Fc, Fs);
Hd = design(h, 'butter');

x1 = x(1:100000);       % Consider only 100000 samples
x2 = randn(1,100000);   % Generate a random signal of length 100000
x3 = x1 + x2;           % Contaminating x1 with random white noise

% Performing FFT to identify frequency components in signal x1
nfftX = length(x1);
nfftX1 = 2^nextpow2(nfftX);
Y = fft(x1,nfftX1);     
xY = Fs*(0:nfftX1/2-1)/nfftX1;
Y1 = Y(1:nfftX1/2); 

% figure('Name','WAV Signal Plots');
subplot(2,3,1);
plot(x1);
xlabel("Time [S]");
ylabel("Amplitude [V]");
title("Original audio signal in Time Domain");
subplot(2,3,4);
plot(xY, abs(Y1),'r');
xlabel("Frequency [Hz]");
ylabel("Magnitude");
title("Original audio signal in Frequency Domain");
% From this, we come to know that the frequencies which are available in
% signal x1 are below 5KHz. So now, we can design filter accordingly.

nfftx3 = length(x3);
nfftx31 = 2^nextpow2(nfftx3);
Y3 = fft(x3,nfftx31);     
x3Y = Fs*(0:nfftx31/2-1)/nfftx31;
Y13 = Y3(1:nfftx31/2);
subplot(2,3,2);
plot(x3);
xlabel("Time [S]");
ylabel("Amplitude [V]");
title("Contaminated signal in Time Domain (Before filtering)");
subplot(2,3,5);
plot(x3Y, abs(Y13), 'r');
axis tight;
xlabel("Frequency [Hz]");
ylabel("Magnitude");
title("Contaminated signal in Frequency Domain (Before filtering)");

% Applying filter to contaminated signal x3
hpfo = filter(Hd, x3);

nffthpfo = length(hpfo);
nffthpfo1 = 2^nextpow2(nffthpfo);
Yhpfo = fft(hpfo,nffthpfo1);     
hpfoY = Fs*(0:nffthpfo1/2-1)/nffthpfo1;
Y1hpfo = Yhpfo(1:nffthpfo1/2);
subplot(2,3,3);
plot(hpfo);
xlabel("Time [S]");
ylabel("Amplitude [V]");
title("High Pass Filter Output in Time Domain");
subplot(2,3,6);
plot(hpfoY, abs(Y1hpfo), 'r');
axis tight;
xlabel("Frequency [Hz]");
ylabel("Magnitude");
title("High Pass Filter Output in Frequency Domain");

soundsc(x, Fs);
soundsc(hpfo, Fs);

% ****************Program ends here**************************