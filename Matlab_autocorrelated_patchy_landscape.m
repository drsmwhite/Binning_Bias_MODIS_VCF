% This code calculates the histograms across theoretical autocorrelated
% patchy landscapes with a beta distribution based on random alpha and beta
 
% initialise parameters
total_cells = 1000; % total_cells along x and y axis
tile_size = 20; % total_cells along the x and y axis within tile
tiles = total_cells/tile_size; % number of tiles along x and y axis
mc_runs = 25000; % total number of runs
max_parameter = 5.5; % maximum of parameter alpha or beta + 0.5 (see below)
 
% initate variables
mean_draw = zeros(1,mc_runs);
mean_bin_store = zeros(1,mc_runs);
mean_real_store = zeros(1,mc_runs);
mean_land_store = zeros(1,mc_runs);
 
mean_bin = 0; % mean of tiles of binned total_cells
median_bin = 0; % median of tiles of binned total_cells
std_bin = 0; % std of tiles of binned total_cells
mean_real = 0; % see above of unbinned total_cells
median_real = 0; % see above of unbinned total_cells
std_real = 0; % see above of unbinned total_cells
mean_land = 0; % mean of cells across the landscape
median_land = 0; % median of cells across the landscape
std_land = 0; % std of cells across the landscape
 
bin_hist = zeros(1,100); % the histogram of tiles for binned total_cells
real_hist = zeros(1,100); % the histogram of tiles for unbinned total_cells
land_hist = zeros(1,100);% the histogram of cells across the landscape
 
% histogram edges
edges=0:100;
 
% run loop for all runs
for bootstrap = 1:mc_runs
    clc
    display(bootstrap)
    
    % initate variables
    tile_landscape_bin = zeros(tiles); % the tiled landscape of binned total_cells
    tile_landscape_real = zeros(tiles); % the tiled landscape of unbinned total_cells
    
    %initiate the landscape of cells
    landscape = zeros(total_cells);
    bin_landscape = zeros(total_cells);
    
    for i=1:tiles %rows
        i_min = ((i-1)*tile_size)+1;
        i_max = i*tile_size;
        for j=1:tiles % columns
            j_min = ((j-1)*tile_size)+1;
            j_max = j*tile_size;
            
            % draw alpha and beta
            alpha = (rand*max_parameter)+0.5;
            beta = (rand*max_parameter)+0.5;            
            land = (betarnd(alpha,beta,tile_size)).*100;
 
            % bin the landscape
            bin_land = land;
            bin_land(bin_land > 60) = 80;
            bin_land(bin_land>40 & bin_land<=60) = 50;
            bin_land(bin_land>10 & bin_land<=40) = 25;
            bin_land(bin_land<=10) = 0;
            
            % define the landscapes
            landscape(i_min:i_max,j_min:j_max) = land;
            bin_landscape(i_min:i_max,j_min:j_max) = bin_land;
            bin_land = reshape (bin_land,1,tile_size^2);
            land = reshape (land,1,tile_size^2);           
            tile_landscape_bin(i,j) =  mean(bin_land);
            tile_landscape_real(i,j) = mean(land);
            
            clear land
            clear bin_land
        end
    end
    
    % create run specific histograms
    a_tile_landscape_bin = reshape(tile_landscape_bin,1,tiles^2);
    a_tile_landscape_real = reshape(tile_landscape_real,1,tiles^2);
    a_landscape = reshape (landscape,1,total_cells^2);
    bin_hist_new = histcounts(a_tile_landscape_bin,edges);
    real_hist_new =  histcounts(a_tile_landscape_real,edges);
    land_hist_new =  histcounts(a_landscape,edges);
    
    % store histograms (as sum of all runs, to save space)
    bin_hist = bin_hist + bin_hist_new;
    real_hist = real_hist + real_hist_new;
    land_hist = land_hist + land_hist_new;
    
    % calculate run spepcfic staistics and store (as sum of all runs, to
    % save space)
    mean_bin = mean_bin + mean(a_tile_landscape_bin);
    median_bin = median_bin + median(a_tile_landscape_bin);
    std_bin = std_bin + std(a_tile_landscape_bin);
    mean_real = mean_real + mean(a_tile_landscape_real);
    median_real = median_real + median(a_tile_landscape_real);
    std_real = std_real  + std(a_tile_landscape_real);
    mean_land = mean_land + mean(a_landscape);
    median_land = median_land + median(a_landscape);
    std_land = std_land  + std(a_landscape);
end
 
% average histograms over the runs
bin_hist = bin_hist/mc_runs;
real_hist = real_hist/mc_runs;
land_hist = land_hist/mc_runs;
 
% average statistics over the runs
mean_bin = mean_bin/mc_runs;
median_bin = median_bin/mc_runs;
std_bin = std_bin/mc_runs;
mean_real = mean_real/mc_runs;
median_real = median_real/mc_runs;
std_real = std_real/mc_runs;
mean_land = mean_land/mc_runs;
median_land = median_land/mc_runs;
std_land = std_land/mc_runs;
 
% correct for sum to 100% (this is the output to Excel)
bin_hist = bin_hist/sum(bin_hist);
real_hist = real_hist/sum(real_hist);
land_hist = land_hist/sum(land_hist);
 
% save output
save('auto_beta.mat')
%xlswrite('auto_beta.xlsx',[bin_hist',real_hist',land_hist']);
 
% plot histograms
h(1)=figure(1);
bar(1:100,bin_hist)
xlabel('% cover')
ylabel('Frequency')
title('Binned')
h(2)=figure(2);
bar(1:100,real_hist)
xlabel('% cover')
ylabel('Frequency')
title('Averaged')
h(3)=figure(3);
bar(1:100,land_hist)
xlabel('% cover')
ylabel('Frequency')
title('Landscape')
savefig(h,'auto_beta.fig')
