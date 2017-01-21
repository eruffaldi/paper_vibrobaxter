% function  []=bar_whisk(x,m,sd,limit,NAME_FIG,COLOR_CODE,LEGENDA,FontSize_LEGEND,BAR_WIDTH_offset)
% input:
% x = ordinate
% m = medie
% sd = dev std; %%% PASSARE UN VETTORE COLONNA!!! Se le colonne sono due
%      viene interpretato come baffo inferiore e baffo superiore. Non sono
%      degli scostamenti dalla media ma proprio i valori.
       %% PERCENTILI NON GAUSSIANI calcolati con prctile
% limit = [x_min x_max y_min y_max] ; limiti ordinate grafico
% NAME_FIG = 'string';     nome figura grafico
%           [default = 'bar whisk']
%           if 'nofigure': la funzione non fa una nuova figura ma grafica
%           sulla figura corrente
% COLOR_CODE = string with code color of each bar [default all bar gray ]
%              or COLOR_CODE must be a matrix  N x 3 where N is the number of color')
%               Each row of COLOR_CODE is a triplette color code'
% LEGENDA = string with the legend
% FontSize_LEGEND =  integer. The Legend-FontSize
% BAR_WIDTH_offset = integer ranging se negativo introduce spazi tra le bar, se positivo ;


%disegna barre  con le whisker bars e il vettore limit come limite assi
%m ? il vettore media sd vettore dev std
%x sono le ordinate
function []=bar_whisk(x,m,sd,limit,NAME_FIG,COLOR_CODE,LEGENDA,FontSize_LEGEND,BAR_WIDTH_offset)

if size(sd,2)==1
    disp([num2str(size(sd,1)),' bar with Whiskers of the same length'])
elseif size(sd,2)==2
    disp([num2str(size(sd,1)),' bar with Whiskers of the different length. The first column of ''sd'' indicate the lower whisker and the second the upper'])
else
    disp(['il vettore delle std ? ',num2str(size(sd))])
    disp('dovrebbe essere UN VETTORE COLONNA!!!')
    disp('Se le colonne sono due  viene interpretato come baffo inferiore e baffo superiore.')
    disp('Non sono degli scostamenti dalla media ma proprio i valori.%% PERCENTILI NON GAUSSIANI calcolati con prctile')
    disp('')
    k = input('traspongo il vettore delle std?, [y=1] , n=0 ');
    if isempty(k);k=1;end
    if k>0
        sd = sd';
    else
        disp('Each row of ''sd'' indicate the deviation of each bar')
        error('SEI DURO!!!')
    end
end


% BAR PROPRIETIES sotti
largh_whisk=0.5;
ErrLineWidth = 2.5;
ErrLineWidthTick = 3; % baffetto alle estremit? della error line
ErrLineSymbol = 'o'; %simbolo in cima alle error bar
ColorErrBar = [0.7 0.7 0.7];
ColorErrBarTick = [ 0 0 0];% baffetto alle estremit? della error line
if exist('BAR_WIDTH_offset','var')==0
    BAR_WIDTH_offset = 0;
end
if isempty(BAR_WIDTH_offset)
    BAR_WIDTH_offset = 0;
end

% if nargin<5;    NAME_FIG = 'bar whisk';elseif strcmp(NAME_FIG,'nofigure');     disp( 'nofigure');else     figure('Name',NAME_FIG);end
if exist('NAME_FIG','var')~=0
    if ~isempty(NAME_FIG)
        figure('Name',NAME_FIG);
    end
end


stile=[' -';' :';'-.';'--'];
% font_size=22;
%  ax=axes;
% set(ax,'Box','on','LineWidth',1,'FontSize',font_size);


grid on
% l1=xlabel('Simulated Jitter (%)');
% set(l1,'Fontsize',font_size);
% l2=ylabel('Estimated Jitter (%)');
%
% set(l2,'Fontsize',font_size);
mean_=squeeze(m);
std_=squeeze(sd);

if nansum(std_)==0 % elimno error tick 
%     ErrLineWidth = 0;
%     ErrLineWidthTick = 0; % baffetto alle estremit? della error line
    largh_whisk = 0;
    ColorErrBarTick = ColorErrBar;
    
end

if nargin<6
    
    p1=bar(x,mean_);
    
    set(p1,'LineStyle',stile(1,:),'LineWidth',1,'FaceColor',[0.5 0.5 0.5]);
    
    
    
    %    set(p1,'LineStyle',stile(index_s,:),'LineWidth',2,'Color',[0 0 0]);
    for index_p=1:length(x)
        
        %    set(p1,'LineStyle',stile(index_s,:),'LineWidth',2,'Color',[0 0 0]);
        hold on
        l_1=line([x(index_p) x(index_p)],[mean_(index_p)-std_(index_p) mean_(index_p)+std_(index_p)]);        hold on
        
        
        if size(sd,2)==1
            %%%% Con righette
            l_1=line([x(index_p) x(index_p)],[mean_(index_p)-std_(index_p) mean_(index_p)+std_(index_p)]);        hold on
            l_3=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ mean_(index_p)-std_(index_p) mean_(index_p)-std_(index_p)]); hold on
            l_2=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ mean_(index_p)+std_(index_p) mean_(index_p)+std_(index_p)]);     hold on
            
            %%% Con pallino
            % %         l_3=plot(x(index_p), [mean_(index_p)-std_(index_p)],ErrLineSymbol);        hold on
            % %         l_2=plot(x(index_p),mean_(index_p)+std_(index_p),ErrLineSymbol);
            %         set(l_3,'Color',ColorErrBarTick,'LineWidth',ErrLineWidthTick);hold on
            
            
        elseif size(sd,2)==2
            l_1=line([x(index_p) x(index_p)],[mean_(index_p)-std_(index_p,1) mean_(index_p)+std_(index_p,2)]);        hold on
            l_3=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ mean_(index_p)-std_(index_p,1) mean_(index_p)-std_(index_p,1)]); hold on
            l_2=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ mean_(index_p)+std_(index_p,2) mean_(index_p)+std_(index_p,2)]);     hold on
        end
        
        set(l_3,'Color',ColorErrBarTick,'MarkerFaceColor',ColorErrBarTick,'LineWidth',ErrLineWidthTick,'MarkerSize',ErrLineWidthTick); % Riga
        set(l_1,'Color',ColorErrBar,'LineWidth',ErrLineWidth);hold on
        set(l_2,'Color',ColorErrBarTick,'LineWidth',ErrLineWidthTick);hold on
        hold on
        %         l_1=line([x(index_p) x(index_p)],[mean_(index_p)-std_(index_p) mean_(index_p)+std_(index_p)]);
        %         l_2=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ mean_(index_p)+std_(index_p) mean_(index_p)+std_(index_p)]);
        %         l_3=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ mean_(index_p)-std_(index_p) mean_(index_p)-std_(index_p)]);
        %         set(l_3,'Color',ColorErrBarTick,'FaceColor',ColorErrBarTick,[0.5 0.5 0.5],'LineWidth',ErrLineWidthTick,'MarkerSize',ErrLineWidthTick); % Riga
        %         set(l_1,'Color',ColorErrBar,'LineWidth',ErrLineWidth);
        %         set(l_2,'Color',ColorErrBarTick,'LineWidth',ErrLineWidthTick);
    end
    axis(limit)
    
else
    
    cc=0;
    BAR_WIDTH = mean(diff(x));
    BAR_WIDTH = BAR_WIDTH-BAR_WIDTH_offset;
    largh_whisk = BAR_WIDTH/4;
    for index_p=1:length(x)
        cc=cc+1  ;
        hold on
        if isstr(COLOR_CODE)
            if index_p==length(COLOR_CODE)
                COLOR_CODE = [COLOR_CODE COLOR_CODE];
            end
            h(cc)=bar(x(index_p),mean_(index_p),COLOR_CODE(index_p),'BarWidth',BAR_WIDTH);
            hold on
        else
            if size(COLOR_CODE,2)~=3
                disp('COLOR_CODE must be a matrix  N x 3 where N is the number of color')
                disp('Each row of COLOR_CODE is a triplette color code')
                error('SEI DURO!!!')
            end
            if index_p==size(COLOR_CODE,1)
                COLOR_CODE = [COLOR_CODE; COLOR_CODE];
            end
            h(cc)=bar(x(index_p),mean_(index_p),'BarWidth',BAR_WIDTH);
            set(h(cc),'FaceColor',COLOR_CODE(index_p,:));hold on
            
        end
        %    set(p1,'LineStyle',stile(index_s,:),'LineWidth',2,'Color',[0 0 0]);
        hold on
        
        
        if size(sd,2)==1
            l_1=line([x(index_p) x(index_p)],[mean_(index_p)-std_(index_p) mean_(index_p)+std_(index_p)]);        hold on
            %%%% con pallino
            % % % % %         l_2=plot(x(index_p),mean_(index_p)+std_(index_p),ErrLineSymbol);
            % % % % %         l_3=plot(x(index_p), [mean_(index_p)-std_(index_p)],ErrLineSymbol);        hold on
            %%%%% con righetta
            l_2=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ mean_(index_p)+std_(index_p) mean_(index_p)+std_(index_p)]);     hold on
            l_3=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ mean_(index_p)-std_(index_p) mean_(index_p)-std_(index_p)]); hold on
        elseif size(sd,2)==2 %% PERCENTILI NON GAUSSIANI calcolati con prctile
            l_1=line([x(index_p) x(index_p)],[std_(index_p,1) std_(index_p,2)]);        hold on
%             if std_(index_p,2)~=mean_(index_p)
                l_2=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ std_(index_p,2) std_(index_p,2)]);     hold on
%             end
%             if std_(index_p,1)~=mean_(index_p)
                l_3=line([x(index_p)-largh_whisk x(index_p)+largh_whisk],[ std_(index_p,1) std_(index_p,1)]); hold on
%             end
        end
        
        %                 set(l_3,'Color',ColorErrBarTick,'LineWidth',ErrLineWidthTick);hold on
        
        %         set(l_3,'Color',ColorErrBarTick,'MarkerFaceColor',ColorErrBarTick,'MarkerSize',ErrLineWidthTick);hold on
        set(l_1,'Color',ColorErrBar,'LineWidth',ErrLineWidth);hold on
        
%         if std_(index_p,1)~=mean_(index_p)
            set(l_3,'Color',ColorErrBarTick,'LineWidth',ErrLineWidth);
%         end
%         if std_(index_p,2)~=mean_(index_p)
            set(l_2,'Color',ColorErrBarTick,'LineWidth',ErrLineWidth,'MarkerFaceColor',ColorErrBarTick,'MarkerSize',ErrLineWidthTick);hold on
%         end
        hold on
        
    end
    if ~isempty(limit)
        axis(limit)
    end
end
if exist('LEGENDA','var')
    if ~isempty(LEGENDA)
        %     legend(h,LEGENDA)
        AX=legend(h,LEGENDA, 'Location','SouthEast');
        LEG_Texts_Handle = findobj(AX,'type','text');
        
        if exist('FontSize_LEGEND','var')
            if ~isempty(FontSize_LEGEND)
                set(LEG_Texts_Handle,'FontSize',FontSize_LEGEND)
            end
        end
    end
end
hold off

