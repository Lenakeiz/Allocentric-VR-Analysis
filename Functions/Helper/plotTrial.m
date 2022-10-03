function plotTrial(AlloData, subjId, trialNumber)
    close all;
    
    gpX = [-3.0 4.88 10.5 11.8 11.8 6.0 6.0 -0.3 -0.42 -3.0]';
    gpZ = [-8.7 -8.7 -6.1 -1.33 2.73 2.73 -0.74 -0.74 -4.6 -4.6]';
    
    p  = patch('XData', gpX,'YData', gpZ); hold on;
    p.FaceAlpha = 0.1;
    
    exData = AlloData(AlloData.ParticipantID == subjId & AlloData.TrialNumber == trialNumber, :);
    
    for i = 1:4
        text(exData.X(i), exData.Z(i) ,num2str(exData.ObjectID(i)), 'HorizontalAlignment', 'center'); hold on;
        %plotcircle(exData.X(i), exData.Z(i), exData.RecCalculatedAbsError(i), [0 0 0]);
    end
    
    for i = 1:4
        text(exData.RegX(i), exData.RegZ(i) ,[num2str(exData.ObjectID(i)) 'R'], 'HorizontalAlignment', 'center'); hold on;
    end
    
    hold off;
    
    axis equal;
    
end

function h = plotcircle(x,y,r,color)
    th = 0:pi/(50):2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit,'--','Marker','none','MarkerSize',3,'LineStyle',':','LineWidth',1.5,'Color',color); hold on;
end
