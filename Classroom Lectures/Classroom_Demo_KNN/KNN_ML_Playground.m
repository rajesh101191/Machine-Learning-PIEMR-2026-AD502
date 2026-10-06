
function KNN_ML_Playground
% ==============================================================
%                 KNN MACHINE LEARNING PLAYGROUND
% ==============================================================
%
% MATLAB R2016b compatible
%
% This program demonstrates K-Nearest Neighbours interactively.
%
% WORKFLOW
% --------
% 1. Select Class 1 or Class 2
% 2. Click on the graph to create training points
% 3. Select K
% 4. Click TRAIN KNN
% 5. Click anywhere on the graph to create a test point
% 6. The program shows:
%       - K nearest neighbours
%       - distances
%       - votes
%       - predicted class
%       - decision regions
%
% No Statistics and Machine Learning Toolbox required.
% ==============================================================

clc;
close all;

%% =============================================================
%  VARIABLES
% =============================================================

class1 = [];
class2 = [];

isTrained = false;

currentTestPoint = [];

%% =============================================================
% MAIN FIGURE
% =============================================================

fig = figure( ...
    'Name','KNN Machine Learning Playground', ...
    'NumberTitle','off', ...
    'Color',[1 1 1], ...
    'Position',[80 60 1250 750], ...
    'MenuBar','none', ...
    'Resize','off');

%% =============================================================
% GRAPH
% =============================================================

ax = axes( ...
    'Parent',fig, ...
    'Units','normalized', ...
    'Position',[0.06 0.12 0.67 0.80]);

hold(ax,'on');

xlim(ax,[0 10]);
ylim(ax,[0 10]);

grid(ax,'on');
box(ax,'on');

set(ax, ...
    'FontSize',11, ...
    'XTick',0:1:10, ...
    'YTick',0:1:10);

xlabel(ax,'Feature 1','FontSize',12);
ylabel(ax,'Feature 2','FontSize',12);

title(ax, ...
    'KNN Machine Learning Playground', ...
    'FontSize',17, ...
    'FontWeight','bold');

%% =============================================================
% CONTROL PANEL
% =============================================================

panel = uipanel( ...
    'Parent',fig, ...
    'Units','normalized', ...
    'Position',[0.76 0.05 0.22 0.90], ...
    'Title','KNN Controls', ...
    'FontSize',12, ...
    'FontWeight','bold');

%% =============================================================
% INSTRUCTIONS
% =============================================================

uicontrol( ...
    'Parent',panel, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',[0.06 0.78 0.88 0.16], ...
    'String',{ ...
    '1. Select a class'; ...
    '2. Click on graph to add points'; ...
    '3. Select K'; ...
    '4. Click TRAIN KNN'; ...
    '5. Click graph to test a new point'}, ...
    'HorizontalAlignment','left', ...
    'FontSize',9);

%% =============================================================
% CLASS SELECTION
% =============================================================

uicontrol( ...
    'Parent',panel, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',[0.06 0.735 0.88 0.035], ...
    'String','Training data', ...
    'HorizontalAlignment','left', ...
    'FontWeight','bold', ...
    'FontSize',10);

classGroup = uibuttongroup( ...
    'Parent',panel, ...
    'Units','normalized', ...
    'Position',[0.06 0.625 0.88 0.105], ...
    'Title','Select class');

radioClass1 = uicontrol( ...
    'Parent',classGroup, ...
    'Style','radiobutton', ...
    'String','Class 1', ...
    'Units','normalized', ...
    'Position',[0.08 0.50 0.84 0.40], ...
    'FontSize',10);

radioClass2 = uicontrol( ...
    'Parent',classGroup, ...
    'Style','radiobutton', ...
    'String','Class 2', ...
    'Units','normalized', ...
    'Position',[0.08 0.05 0.84 0.40], ...
    'FontSize',10);

classGroup.SelectedObject = radioClass1;

%% =============================================================
% K CONTROL
% =============================================================

uicontrol( ...
    'Parent',panel, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',[0.06 0.575 0.88 0.035], ...
    'String','Number of neighbours (K)', ...
    'HorizontalAlignment','left', ...
    'FontWeight','bold', ...
    'FontSize',10);

kSlider = uicontrol( ...
    'Parent',panel, ...
    'Style','slider', ...
    'Min',1, ...
    'Max',15, ...
    'Value',3, ...
    'SliderStep',[1/14 1/14], ...
    'Units','normalized', ...
    'Position',[0.06 0.525 0.65 0.045], ...
    'Callback',@changeK);

kValueText = uicontrol( ...
    'Parent',panel, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',[0.73 0.515 0.20 0.055], ...
    'String','K = 3', ...
    'FontWeight','bold', ...
    'FontSize',11);

%% =============================================================
% TRAIN BUTTON
% =============================================================

uicontrol( ...
    'Parent',panel, ...
    'Style','pushbutton', ...
    'String','TRAIN KNN', ...
    'Units','normalized', ...
    'Position',[0.06 0.43 0.88 0.065], ...
    'FontSize',11, ...
    'FontWeight','bold', ...
    'Callback',@trainModel);

%% =============================================================
% UNDO BUTTON
% =============================================================

uicontrol( ...
    'Parent',panel, ...
    'Style','pushbutton', ...
    'String','UNDO LAST POINT', ...
    'Units','normalized', ...
    'Position',[0.06 0.355 0.42 0.055], ...
    'FontSize',9, ...
    'Callback',@undoPoint);

%% =============================================================
% CLEAR BUTTON
% =============================================================

uicontrol( ...
    'Parent',panel, ...
    'Style','pushbutton', ...
    'String','CLEAR ALL', ...
    'Units','normalized', ...
    'Position',[0.52 0.355 0.42 0.055], ...
    'FontSize',9, ...
    'Callback',@clearAll);

%% =============================================================
% RESULT PANEL
% =============================================================

uicontrol( ...
    'Parent',panel, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',[0.06 0.315 0.88 0.03], ...
    'String','KNN Result', ...
    'HorizontalAlignment','left', ...
    'FontWeight','bold');

resultBox = uicontrol( ...
    'Parent',panel, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',[0.06 0.075 0.88 0.235], ...
    'String',{ ...
    'Create training data first.'; ...
    ''; ...
    'Red = Class 1'; ...
    'Blue = Class 2'}, ...
    'HorizontalAlignment','left', ...
    'FontSize',9, ...
    'BackgroundColor',[0.95 0.95 0.95]);

%% =============================================================
% FIGURE MOUSE CALLBACK
% =============================================================

set(fig,'WindowButtonDownFcn',@graphClicked);


%% =============================================================
% CALLBACK: CHANGE K
% =============================================================

function changeK(~,~)

    k = round(get(kSlider,'Value'));

    set(kSlider,'Value',k);

    set(kValueText, ...
        'String',['K = ' num2str(k)]);

    % If model already exists, redraw decision boundary
    if isTrained

        if ~isempty(class1) && ~isempty(class2)

            trainModel();

        end

    end

end


%% =============================================================
% CALLBACK: GRAPH CLICK
% =============================================================

function graphClicked(~,~)

    % ----------------------------------------------------------
    % Get mouse location
    % ----------------------------------------------------------

    point = get(ax,'CurrentPoint');

    x = point(1,1);
    y = point(1,2);

    % ----------------------------------------------------------
    % Check whether point is inside graph
    % ----------------------------------------------------------

    if x < 0 || x > 10 || y < 0 || y > 10

        return;

    end

    % ----------------------------------------------------------
    % BEFORE TRAINING
    % Add training data
    % ----------------------------------------------------------

    if ~isTrained

        selectedClass = classGroup.SelectedObject;

        if selectedClass == radioClass1

            class1 = [class1; x y];

            plot(ax,x,y, ...
                'ro', ...
                'MarkerSize',9, ...
                'MarkerFaceColor','r', ...
                'LineWidth',1.5);

        else

            class2 = [class2; x y];

            plot(ax,x,y, ...
                'bo', ...
                'MarkerSize',9, ...
                'MarkerFaceColor','b', ...
                'LineWidth',1.5);

        end

        updateTrainingInformation();

    % ----------------------------------------------------------
    % AFTER TRAINING
    % Classify new point
    % ----------------------------------------------------------

    else

        classifyPoint([x y]);

    end

end


%% =============================================================
% UPDATE TRAINING INFORMATION
% =============================================================

function updateTrainingInformation()

    n1 = size(class1,1);
    n2 = size(class2,1);

    set(resultBox,'String',{ ...
        'TRAINING DATA'; ...
        ''; ...
        ['Class 1 points = ' num2str(n1)]; ...
        ['Class 2 points = ' num2str(n2)]; ...
        ''; ...
        'Select both classes'; ...
        'then click TRAIN KNN.'});

end


%% =============================================================
% TRAIN MODEL
% =============================================================

function trainModel(~,~)

    % ----------------------------------------------------------
    % Check data
    % ----------------------------------------------------------

    if isempty(class1)

        errordlg( ...
            'Please create Class 1 points first.', ...
            'Missing Class 1');

        return;

    end

    if isempty(class2)

        errordlg( ...
            'Please create Class 2 points first.', ...
            'Missing Class 2');

        return;

    end

    % ----------------------------------------------------------
    % Prepare training data
    % ----------------------------------------------------------

    trainingData = [class1; class2];

    trainingData = reshape(trainingData,[],2);

    labels = [ ...
        ones(size(class1,1),1); ...
        2*ones(size(class2,1),1)];

    % ----------------------------------------------------------
    % K
    % ----------------------------------------------------------

    k = round(get(kSlider,'Value'));

    totalPoints = size(trainingData,1);

    if k > totalPoints

        k = totalPoints;

        set(kSlider,'Value',k);

        set(kValueText, ...
            'String',['K = ' num2str(k)]);

    end

    % ----------------------------------------------------------
    % Mark model as trained
    % ----------------------------------------------------------

    isTrained = true;

    currentTestPoint = [];

    % ----------------------------------------------------------
    % Clear graph
    % ----------------------------------------------------------

    cla(ax);

    hold(ax,'on');

    % ----------------------------------------------------------
    % Create grid
    % ----------------------------------------------------------

    resolution = 100;

    xValues = linspace(0,10,resolution);
    yValues = linspace(0,10,resolution);

    [X,Y] = meshgrid(xValues,yValues);

    gridPoints = [X(:) Y(:)];

    predictions = zeros(size(gridPoints,1),1);

    % ----------------------------------------------------------
    % KNN prediction for every grid point
    % ----------------------------------------------------------

    for i = 1:size(gridPoints,1)

        % Difference between every training point
        % and current grid point

        difference = bsxfun( ...
            @minus, ...
            trainingData, ...
            gridPoints(i,:));

        % Euclidean distance

        distances = sqrt( ...
            sum(difference.^2,2));

        % Sort distances

        [~,sortedIndex] = sort(distances);

        % Select K neighbours

        nearestIndex = ...
            sortedIndex(1:k);

        nearestLabels = ...
            labels(nearestIndex);

        % Majority vote

        predictions(i) = mode(nearestLabels);

    end

    % ----------------------------------------------------------
    % Convert prediction vector into grid
    % ----------------------------------------------------------

    Z = reshape( ...
        predictions, ...
        size(X));

    % ----------------------------------------------------------
    % Draw decision regions
    % ----------------------------------------------------------

    contourf( ...
        ax, ...
        X, ...
        Y, ...
        Z, ...
        [1 1.5 2], ...
        'LineColor','none');

    % ----------------------------------------------------------
    % Transparency
    % ----------------------------------------------------------

    h = findobj(ax,'Type','patch');

    if ~isempty(h)

        set(h,'FaceAlpha',0.18);

    end

    % ----------------------------------------------------------
    % Draw training points
    % ----------------------------------------------------------

    plotClassPoints();

    % ----------------------------------------------------------
    % Graph formatting
    % ----------------------------------------------------------

    xlim(ax,[0 10]);
    ylim(ax,[0 10]);

    grid(ax,'on');
    box(ax,'on');

    xlabel(ax,'Feature 1','FontSize',12);
    ylabel(ax,'Feature 2','FontSize',12);

    title(ax, ...
        ['KNN Decision Boundary     K = ' num2str(k)], ...
        'FontSize',16, ...
        'FontWeight','bold');

    legend(ax, ...
        {'Class 1','Class 2'}, ...
        'Location','northwest');

    % ----------------------------------------------------------
    % Result
    % ----------------------------------------------------------

    set(resultBox,'String',{ ...
        'MODEL TRAINED'; ...
        ''; ...
        ['K = ' num2str(k)]; ...
        ''; ...
        ['Class 1 = ' num2str(size(class1,1)) ' points']; ...
        ['Class 2 = ' num2str(size(class2,1)) ' points']; ...
        ''; ...
        'Click anywhere on the graph'; ...
        'to classify a NEW point.'});

end


%% =============================================================
% DRAW CLASS POINTS
% =============================================================

function plotClassPoints()

    if ~isempty(class1)

        plot(ax, ...
            class1(:,1), ...
            class1(:,2), ...
            'ro', ...
            'MarkerSize',9, ...
            'MarkerFaceColor','r', ...
            'LineWidth',1.5);

    end

    if ~isempty(class2)

        plot(ax, ...
            class2(:,1), ...
            class2(:,2), ...
            'bo', ...
            'MarkerSize',9, ...
            'MarkerFaceColor','b', ...
            'LineWidth',1.5);

    end

end


%% =============================================================
% CLASSIFY A NEW POINT
% =============================================================

function classifyPoint(point)

    % ----------------------------------------------------------
    % Prepare training data
    % ----------------------------------------------------------

    trainingData = [class1; class2];

    trainingData = reshape(trainingData,[],2);

    labels = [ ...
        ones(size(class1,1),1); ...
        2*ones(size(class2,1),1)];

    % ----------------------------------------------------------
    % K
    % ----------------------------------------------------------

    k = round(get(kSlider,'Value'));

    k = min(k,size(trainingData,1));

    % ----------------------------------------------------------
    % Calculate distances
    % ----------------------------------------------------------

    difference = bsxfun( ...
        @minus, ...
        trainingData, ...
        point);

    distances = sqrt( ...
        sum(difference.^2,2));

    % ----------------------------------------------------------
    % Sort distances
    % ----------------------------------------------------------

    [sortedDistances,sortedIndex] = ...
        sort(distances);

    % ----------------------------------------------------------
    % K nearest neighbours
    % ----------------------------------------------------------

    nearestIndex = ...
        sortedIndex(1:k);

    nearestDistances = ...
        sortedDistances(1:k);

    nearestLabels = ...
        labels(nearestIndex);

    % ----------------------------------------------------------
    % Majority voting
    % ----------------------------------------------------------

    class1Votes = sum(nearestLabels == 1);

    class2Votes = sum(nearestLabels == 2);

    predictedClass = mode(nearestLabels);

    % ----------------------------------------------------------
    % Remove previous test visualisation
    % ----------------------------------------------------------

    delete(findobj(ax,'Tag','KNN_TEST_POINT'));

    delete(findobj(ax,'Tag','KNN_NEIGHBOUR_LINE'));

    delete(findobj(ax,'Tag','KNN_DISTANCE_CIRCLE'));

    % ----------------------------------------------------------
    % Plot test point
    % ----------------------------------------------------------

    plot(ax, ...
        point(1), ...
        point(2), ...
        'kp', ...
        'MarkerSize',17, ...
        'MarkerFaceColor','y', ...
        'LineWidth',2, ...
        'Tag','KNN_TEST_POINT');

    % ----------------------------------------------------------
    % Draw lines to nearest neighbours
    % ----------------------------------------------------------

    for j = 1:k

        neighbour = ...
            trainingData(nearestIndex(j),:);

        plot(ax, ...
            [point(1) neighbour(1)], ...
            [point(2) neighbour(2)], ...
            'k--', ...
            'LineWidth',1, ...
            'Tag','KNN_NEIGHBOUR_LINE');

    end

    % ----------------------------------------------------------
    % Draw K-th neighbour circle
    % ----------------------------------------------------------

    radius = nearestDistances(k);

    theta = linspace(0,2*pi,200);

    circleX = ...
        point(1) + radius*cos(theta);

    circleY = ...
        point(2) + radius*sin(theta);

    plot(ax, ...
        circleX, ...
        circleY, ...
        'k:', ...
        'LineWidth',1.5, ...
        'Tag','KNN_DISTANCE_CIRCLE');

    % ----------------------------------------------------------
    % Prediction text
    % ----------------------------------------------------------

    if predictedClass == 1

        predictionText = 'CLASS 1';

    else

        predictionText = 'CLASS 2';

    end

    % ----------------------------------------------------------
    % Update result panel
    % ----------------------------------------------------------

    set(resultBox,'String',{ ...
        'NEW POINT'; ...
        ''; ...
        ['Location = (' ...
        num2str(point(1),'%.2f') ', ' ...
        num2str(point(2),'%.2f') ')']; ...
        ''; ...
        ['K = ' num2str(k)]; ...
        ''; ...
        ['Class 1 votes = ' num2str(class1Votes)]; ...
        ['Class 2 votes = ' num2str(class2Votes)]; ...
        ''; ...
        ['PREDICTION = ' predictionText]; ...
        ''; ...
        'Yellow = test point'; ...
        'Dashed = K neighbours'; ...
        'Circle = distance to Kth neighbour'});

    % ----------------------------------------------------------
    % Command window information
    % ----------------------------------------------------------

    fprintf('\n');
    fprintf('============================================\n');
    fprintf('              KNN PREDICTION\n');
    fprintf('============================================\n');

    fprintf('Test point: (%.3f, %.3f)\n', ...
        point(1),point(2));

    fprintf('K = %d\n\n',k);

    fprintf('Nearest neighbours:\n');

    for j = 1:k

        neighbour = ...
            trainingData(nearestIndex(j),:);

        fprintf( ...
            '%2d. (%.3f, %.3f)   Distance = %.4f   Class = %d\n', ...
            j, ...
            neighbour(1), ...
            neighbour(2), ...
            nearestDistances(j), ...
            nearestLabels(j));

    end

    fprintf('\n');
    fprintf('Class 1 votes = %d\n',class1Votes);
    fprintf('Class 2 votes = %d\n',class2Votes);

    fprintf('\nPrediction = Class %d\n', ...
        predictedClass);

    fprintf('============================================\n');

end


%% =============================================================
% UNDO LAST POINT
% =============================================================

function undoPoint(~,~)

    if isTrained

        warndlg( ...
            'Undo is available only before training. Click CLEAR ALL to start again.', ...
            'Model already trained');

        return;

    end

    selectedClass = classGroup.SelectedObject;

    if selectedClass == radioClass1

        if ~isempty(class1)

            class1(end,:) = [];

        end

    else

        if ~isempty(class2)

            class2(end,:) = [];

        end

    end

    % Redraw graph

    cla(ax);

    hold(ax,'on');

    plotClassPoints();

    xlim(ax,[0 10]);
    ylim(ax,[0 10]);

    grid(ax,'on');
    box(ax,'on');

    xlabel(ax,'Feature 1');
    ylabel(ax,'Feature 2');

    title(ax, ...
        'KNN Machine Learning Playground', ...
        'FontSize',17, ...
        'FontWeight','bold');

    updateTrainingInformation();

end


%% =============================================================
% CLEAR ALL
% =============================================================

function clearAll(~,~)

    class1 = [];
    class2 = [];

    currentTestPoint = [];

    isTrained = false;

    cla(ax);

    hold(ax,'on');

    xlim(ax,[0 10]);
    ylim(ax,[0 10]);

    grid(ax,'on');
    box(ax,'on');

    xlabel(ax,'Feature 1');
    ylabel(ax,'Feature 2');

    title(ax, ...
        'KNN Machine Learning Playground', ...
        'FontSize',17, ...
        'FontWeight','bold');

    set(resultBox,'String',{ ...
        'Create training data first.'; ...
        ''; ...
        'Red = Class 1'; ...
        'Blue = Class 2'});

end

end
