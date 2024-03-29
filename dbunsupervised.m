switch db    
    case 'cats'
        fid = fopen('database/CATS.txt');
        seriesRaw = fscanf(fid, '%f');
        
        series = zeros(size(seriesRaw));
        maxValue = max(seriesRaw);
        minValue = min(seriesRaw);
        meanValue = mean(seriesRaw);
        stdValue = std(seriesRaw);
        % [-1, 1]
%         for i=1:size(seriesRaw, 1)
%             series(i, 1) = (seriesRaw(i, 1) - maxValue - minValue) / (maxValue - minValue);            
%         end
        % [0, 1]
        series = (seriesRaw - min(seriesRaw)) / (max(seriesRaw) - min(seriesRaw));
        % N(0, 1)
%         for i=1:size(seriesRaw, 1)
%             series(i, 1) = (seriesRaw(i, 1) - meanValue) / stdValue;            
%         end
                
        data1Block = zeros(980 - n + 1, n);
        data2Block = zeros(980 - n + 1, n);
        data3Block = zeros(980 - n + 1, n);
        data4Block = zeros(980 - n + 1, n);
        data5Block = zeros(980 - n + 1, n);        
        
        j = 1;
        for i=1:980-n+1
            data1Block(j, :) = series(i:i+n-1)';
            j = j + 1;
        end        
        j = 1;
        for i=981:1960-n+1            
            data2Block(j, :) = series(i:i+n-1)';
            j = j + 1;
        end    
        j = 1;
        for i=1961:2940-n+1
            data3Block(j, :) = series(i:i+n-1)';
            j = j + 1;
        end   
        j = 1;
        for i=2941:3920-n+1
            data4Block(j, :) = series(i:i+n-1)';
            j = j + 1;
        end   
        j = 1;
        for i=3921:4900-n+1
            data5Block(j, :) = series(i:i+n-1)';
            j = j + 1;
        end
        
        data = [data1Block; data2Block; data3Block; data4Block; data5Block];
        
        numbatches = floor(size(data, 1) / batchsize);
        batchdata = zeros(batchsize, n, numbatches);
        randomorder=randperm(size(data, 1));
        
        for b=1:numbatches
            batchdata(:,:,b) = data(randomorder(1+(b-1)*batchsize:b*batchsize), :);            
        end;
        
    case {'acidentes', 'bjd', 'scr', 'tri', 'elec'}
        fid = fopen(strcat(db,'.trn.dat'));
        seriesRaw = fscanf(fid, '%f');
        series = seriesRaw;
        
%         % remove trend        
%         for a=2:size(seriesRaw,1)
%             series(a, 1) = seriesRaw(a, 1) - seriesRaw(a-1, 1);            
%         end
%         
%         % remove seasonality
%         season = 12;
%         for a=1+season:size(seriesRaw,1)
%             series(a, 1) = series(a, 1) - series(a-12, 1);            
%         end
       
        % [0, 1]
        series = (series - min(series)) / (max(series) - min(series));     
        
        %series = seriesRaw;
        
        data = zeros(size(series, 1) - n + 1, n);
        
        for i=1:size(data, 1)
            data(i, :) = series(i:i+n-1);            
        end    
        
        batchsize = size(data, 1); %10
        numbatches = floor(size(data, 1)/batchsize);                      
        batchdata = zeros(batchsize, n, numbatches);
        randomorder=randperm(size(data, 1));
        
        for b=1:numbatches
            batchdata(:,:,b) = data(randomorder(1+(b-1)*batchsize:b*batchsize), :);            
        end;
        
end