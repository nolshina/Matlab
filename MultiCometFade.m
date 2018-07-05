%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MyComet function to plot fading trajectory.
% By: Noam Olshina
% Date: 05-07-2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arguments:
% 1. ax: axes handle on which to plot trajectories
% 2. steps: number of steps in the trajectory vector to plot at once.
% 3. numseg: number of segments that tail is divided up in
% 4. varargin: Trajectory data. 
%     (a) Each 'argin' is made up of 2 rows. The top row is the 'x'
%         data (could be time), the bottom row is the 'y' data.
%     (b) NOTE: The trajectories must be of the same length
%     (c) NOTE: For more than 8 trajecties, add rows into color matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function MultiCometFade(ax,steps,numseg,varargin)
%% modify these parameters
VIDEO = 'on';
VIDEO = 'off'; %comment out to turn video on
% frames per sec in video
FRAMES_PER_SEC = 25;
% Length of comet tail
TAILLENGTH = 40;
%%
% Number of trajectories to plot
numTraj = nargin-3; % 3 is for the first three arguments
% Length of Trajecties
lenTraj = length(varargin{1}(1,:)); 

if strcmp(VIDEO,'on')
    writerObj = VideoWriter('out.avi'); % Name it.
    writerObj.FrameRate = FRAMES_PER_SEC; % How many frames per second.
    open(writerObj);
end

color = [0 0 0; %black
         0 0 1; %blue
         1 0 0; %red
         0 1 0; %green
         0 1 1; %cyan
         1 0 1; %magenta
         1 1 0]; %yellow
         % add more rows id more than 8 trajectories 

segID = [1:numseg]'; % '1' is close to head, 'end' is away from head
alpha = flip(segID)/numseg;
segment = round(TAILLENGTH*flip(alpha));

k = 0; % iteration counter

for i=1:steps:lenTraj
    k = k+1;
    fprintf('percent complete %0.2f \n',100*i/lenTraj);
    delete(findobj(ax, 'Tag', 'head'));
    
    if k>TAILLENGTH+1
        delete(ax.Children([TAILLENGTH*numTraj+1 : TAILLENGTH*numTraj+numTraj])); % delete end of tail
    end
    for j=1:segID(end)
        if k>segment(j)
            for m = 1:numTraj
                ax.Children(numTraj*segment(j)-(m-1)).Color = [color(m,:) alpha(j)];  
            % ax.Children(2*segment(j)).Color = [0 0 0 alpha(j)]; % gray color
            % ax.Children(2*segment(j)-1).Color = [0 0 1 alpha(j)];% light blue color
            end
        end
    end
    
    if i+steps > lenTraj
        steps = lenTraj-i;
    end
    
    for m=1:numTraj 
        x = varargin{m}(1,i:i+steps);
        y = varargin{m}(2,i:i+steps);
        tagname = sprintf('%d,tail %d, traj %d',(2*k-1)+m-1,k,m);
        plot(ax,x,y,'Color',color(m,:),'LineWidth',1,'Tag',tagname );
        s = scatter(ax,x(end),y(end),'filled','Tag','head');
        s.MarkerFaceColor = color(m,:);
    end 
    drawnow;
    if strcmp(VIDEO,'on')
        frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
        writeVideo(writerObj, frame);
    end
end
if strcmp(VIDEO,'on')
    close(writerObj)
end
