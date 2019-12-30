%------------------------------------------------------------------------------------------------------------------------%
%  Sample Matlab Code (Version 0.1) for the Social Mimic Optimization Algorithm and Engineering Applications
%  You just need to introduce your function to be minimized in Costfunc.m. Then enter the SMO parameters
%  and problem parameters(lines 28 to 40).
% 
%  Please refer to the following journal article in your research papers:
%  Saeed Balochian, Hossein Baloochian,
%  Social Mimic Optimization Algorithm and Engineering Applications,
%  Expert Systems with Applications,
%  2019,
%  ISSN 0957-4174, https://doi.org/10.1016/j.eswa.2019.05.035.
%  (http://www.sciencedirect.com/science/article/pii/S0957417419303707).
%
%------------------------------------------------------------------------------------------------------------------------%

function [LeaderFitness]=Mimic
clc
clear ;
global Social PopulationSize ;
global Iteration Rov Dim NFE;

%-------------------------------------------------------
        % Algorithm Control Parameter 
%-------------------------------------------------------
PopulationSize=2;                     % number of population
Iteration=100;                        % number of Iterations
Error=0.000001;                       % Iteration Whit Erorr Less Than
%-------------------------------------------------------
        % Promlem Parameter
%-------------------------------------------------------
Dim=3000;                              % number of problem variables
LB = -30;                             % lower bound
UB = 30;                              % uper bound
%-------------------------------------------------------
        % Rov = [lb1 value ub1 value; ...... ; lbN value ubN value];
        % Example Rov = [0 99; 0 99; 10 200; 10 200];
%-------------------------------------------------------
Rov = ones(Dim,2);
Rov = [LB * Rov(:,1),UB * Rov(:,2)];

NFE = 0;                              %number of function evaluation
%-------------------------------------------------------
        % Initiate Matrix
%-------------------------------------------------------
LeaderFitness=zeros(1,Dim+1);
%-------------------------------------------------------
        % Social = [ variable 1    variable2     ...  Fitness]
%-------------------------------------------------------
Social=zeros(PopulationSize,Dim + 1);
MimicMain;
%-------------------------------------------------------
        % Fitness Function
%-------------------------------------------------------
    function FIT =Fitness (TEMP)
        for i=1:PopulationSize 
            FIT(i, 1) = Costfunc(TEMP(i,1:Dim));
            NFE = NFE +1;
        end      
    end
% /**********************************************/
    function initialize
        for i = 1:PopulationSize
            for j = 1:Dim
                Social(i,j) = randval(Rov(j,1),Rov(j,2));
            end
        end
        INI =Social;
    end

% /**********************************************/
    function MimicMain
        BestITER= inf;
%-------------------------------------------------------
        % initialize Problme
%-------------------------------------------------------
        initialize;
        Social(:,Dim+1) = Fitness (Social); 
        SortMatrix;
        k= min(Social(:,Dim+1));
        fprintf('fitnes0 =%7.5f\n',k);
        for i=1:Iteration
            Mimic(Social(1,Dim+1));
            SortMatrix;
%-------------------------------------------------------
            % Print Fitness Value In Each Iteration
%-------------------------------------------------------
            fprintf('fitness%i =%30.20f\n',i,min(Social(:,Dim+1)));
            ITERATION_RUN(i,1) = Social(1,Dim+1);
            if Social(1,Dim+1)> Error
                BestITER=i;
            end
        end
        LeaderFitness =Social(1,:);
        fprintf('\n');
        fprintf('-----------------------------------------------------------\n');
        fprintf('Iteration Whit Erorr Less Than 0.000001 = %3d ',BestITER+1);
        fprintf('\n');
        fprintf('Number Of Function Eval. = %d',NFE);
        fprintf('\n');
        %LeaderFitness(length(LeaderFitness)+1)=BestITER+1;
        %LeaderFitness(length(LeaderFitness)+1)=NFE;
        fprintf('Best Answer =');
        fprintf('  %10.8f ',LeaderFitness');
    end
% /**********************************************/
    function Mimic(Leader)
        
        POP = Social;
        for i=1:PopulationSize
            Percent = ((Leader-Social(i,Dim+1))/Leader);
            if ( Percent == 0 )
                Percent= -rand(1);
            end
            for j=1:Dim
                CH = ChekVal((POP(i,j)+ Percent*POP(i,j)),j);
                if CH==0
                    POP(i,j) = POP(i,j)+ Percent*POP(i,j);
                else
                    POP(i,j) = randval(Rov(j,1),Rov(j,2));
                end
            end
        end
        POP(:,Dim+1) = Fitness (POP);
        for i=1:PopulationSize
            if ( POP(i,Dim+1)< Social(i,Dim+1))
                Social(i,:) = POP(i,:);
            end
        end
        
    end %function           
% /**********************************************/
    function SortMatrix
        zn= Social(:,Dim+1);
        [L,Index]=sort(zn);
        for i = 1:Dim+1
            X = Social(:,i);
            X = X(Index);
            TEMP(:,i)= X';
        end
        Social=TEMP;
    end %function
% /**********************************************/
    function CoVal = ChekVal(Value, Index)
        CoVal=0;
        if Value < Rov(Index,1)
            CoVal=1;
        elseif Value > Rov(Index,2)
            CoVal=1;
        end

    end
end
%% /**********************************************/
function val1=randval(Maxv,Minv)
    val1=rand(1)*(Maxv-Minv)+Minv;
end


