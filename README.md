# Matlab-Grader-Framework
This is a collection of standalone functions that can be integrated into MATLAB®-Grader tasks to improve testing. It allows for more diverse tests, easier test creation and more freedom while solving.  
Please keep in mind that this library was created "as needed". It is not guranteed to be bug free and may seem inconsequential.  
   
If you are missing something or have ideas for stuff to improve, get in touch, write an [eMail](mailto:david.kosfelder@tu-dortmund.de).

## Overview
* [General information](#general-information)
  * [Integration](#Integration)
  * [Function and script based solutions](#Function-and-script-based-solutions)
  * [Function naming](#function-naming)
* [Functions](#Functions)
  * [Failing or completing a test](#Failing-or-completing-a-test)
    * [mg_setTestStatus](#mg_setTestStatus)
    * [mg_multiText](#mg_multiText)
  * [Sharing information between tests](#Sharing-information-between-tests)
    * [mg_writeSharedVariables](#mg_writeSharedVariables)
    * [mg_loadSharedVariables](#mg_loadSharedVariables)
  * [Graphic evalutaion](#Graphic-evaluation)
    * [mg_plotExists](#mg_plotExists)
    * [mg_getPlotInfo](#mg_getPlotInfo)
    * [mg_isCurveInPlot](#mg_isCurveInPlot)
  * [Advanced Testing](#advanced-testing)
    * [mg_keywordsPresent](#mg_keywordsPresent)
    * [mg_keywordsAbsent](#mg_keywordsAbsent)
    * [mg_keywordsEither](#mg_keywordsEither)
    * [mg_solutionContainsExplicit](#mg_solutionContainsExplicit)
    * [mg_equalsStrictOrder](#mg_equalsStrictOrder)
    * [mg_equalsIgnoreOrder](#mg_equalsIgnoreOrder)
    * [mg_compArrIgnDim](#mg_compArrIgnDim)
    * [mg_varExists](#mg_varExists)
    * [mg_isFunction](#mg_isFunction)
    * [mg_getSolutionFunction](#mg_getSolutionFunction)
    * [mg_evalSolutionFunction](#mg_evalSolutionFunction)
  
## General information
Even though the functions worked fine in our tasks, it is not recommended to use them for real grading. 

### Integration
The desired function can simply be uploaded to the desired MATLAB®-Grader Task. Every file is a standalone. You can call these functions in code based tests.
### Function and script based solutions
MATLAB®-Grader differentiates between functions and scripts as solutions. Therefore, some of the functions only work in specific cases.
### Function Naming
You will notice that all function names start with "mg_". Some functions are able to find the solution function, thus giving the person solving the freedom of naming it on their own. "mg_" excludes these files from the filter. You can add "mg_" to your personal files to avoid trouble. If you do not want to do that, you can also tell the filter not to look for functions containing certain keywords.

## Functions

### Failing or completing a test

You can fail a test by generating an error. Furthermore this collection contains a wrapper.

#### mg_setTestStatus
Wrapper to either fail a test or do nothing.
Following usage literally does nothing.
```matlab
mg_setTestSatus(true(), "some text");
```
Following usage fails a test with the message "some text".
```matlab
mg_setTestSatus(false(), "some text");
```
#### mg_multiText
Returns a formatted string. The base string can contain "%s" which will be replaced by the following input strings. The base string will be repeated once for every following input and create a new line.
```matlab
mg_multiText("Variable %s is wrong.", "a", "b", "f")
mg_multiText("Variable %s is wrong.", ["a", "b", "f"])
```
In both cases the code above would generate the following string (with \n formation).  
  Variable a is wrong.  
  Variable b is wrong.  
  Variable f is wrong.  
  
This can also be use with [mg_setTestStatus](#mg_setTestStatus)
```matlab
msg = mg_multiText("Variable %s is wrong.", "a", "b", "f");
mg_setTestSatus(false(), msg);
```
### Sharing information between tests
These functions allow you to store variables in a test and recall them in a later one. Keep in mind that the tests are executed in order. It is only possible to save something in one test and then load it in a following one. 

#### mg_writeSharedVariables
This functions allows you to store Variables in a test and make them able to be recalled later. It has to be executed in a test before the values can be loaded in another one. It works simmilar to the save() function. The output returns true(), if the saving operation was successful. 
```matlab
mg_writeSharedVariables(); % Saves all variables declared in the current test
mg_writeSharedVariables("a", "b"); % Only saves variables a and b
```

#### mg_loadSharedVariables
This functions allows you to load stored Variables. It can only be used after you saved something. Otherwise it will return a false() output.
```matlab
mg_loadSharedVariables(); % Loads all previously stored variables
mg_loadSharedVariables("a", "b"); % Only loads variables a and b
```

### Graphic Evalutaion
These functions grab information from the graph that is drawn by a student solution.

#### mg_plotExists
Returns a bool that indicates if a plot was created by the solution.
```matlab
if mg_plotExists()
  % do stuff
end
```

#### mg_getPlotInfo
Returns a struct with the following fields. If no plot exists, fields will be empty.

| Field       | Type           | Description  | Field       | Type           | Description  |
| :-------------:|:-------------:| ------------| :-------------:|:-------------:| ------------|
| title      |1x1 text|Title object|zScale|string|Information about the z axis scale|
|titleString|string|Title as string|xGrid|bool|true() when x axis grid is active|
|xLabel|string|Label of x axis|yGrid|bool|true() when y axis grid is active|
|yLabel|string|Label of y axis|zGrid|bool|true() when z axis grid is active|
|zLabel|string|Label of z axis|lines|nx1 line|Array of existing [lines](https://www.mathworks.com/help/matlab/ref/matlab.graphics.primitive.line-properties.html)|
|xLimits|1x2 vector|Limit vector [min max] of x axis|linecount|int|Amount of drawn lines/graphs|
|yLimits|1x2 vector|Limit vector [min max] of y axis|legend|1x1 legend|Legend object|
|zLimits|1x2 vector|Limit vector [min max] of z axis|legendAvailable|bool|true() when legend exists|
|xScale|string|Information about the x axis scale|legendTitle|string|Title of legend as string|
|yScale|string|Information about the y axis scale|legendText|1xn string|Array of names used in the legend. Order is depending on the solution|

#### mg_isCurveInPlot

This function allows you to search for a specified line in the plot drawn by the solution. Multiple lines are supported, but you can only search for one line at a time per function call. The returned value is a bool that is true, if all required properties fit to at least one line in the graph. Only the properties that shall be checked need to be specified. Specification works via key-value ash shown in the following example. An even number of inputs and at least two arguments must be given. For more information check out the [line](https://www.mathworks.com/help/matlab/ref/matlab.graphics.primitive.line-properties.html) object.
```matlab
% Checking for two lines in one graph
A = mg_isCurveInPlot('XData', [0, 1, 2, 3], 'YData', [0, 1, 2, 9], 'Color', [0 0 1], 'LineStyle', '--'); % Example for a blue dashed parabola
B = mg_isCurveInPlot('XData', [0, 1, 2, 3], 'YData', [0, 1, 2, 9], 'Color', [1 1 0], 'LineStyle', 'none', 'Marker', '*'); % Example for yellow stars on a linear function without a line
if (A & B)
  % do stuff
end
```

|Key|Type|Description|Key|Type|Description|
| :-------------:|:-------------:| ------------| :-------------:|:-------------:| ------------|
| 'AlignVertexCenters' | 'on'/'off' | Sharp vertical and horizontal lines | 'MarkerFaceColor' | RGB triplet | Inner color of marker |
| 'Annotation' | Annotation object | Control for including or excluding object from legend | 'Parent' | Axes Object | Parent Object |
| 'BeingDeleted' | 'on'/'off' | Deletion status | 'PickableParts' | 'visible' / 'all' / 'none' | Ability to capture mouse clicks |
| 'BusyAction' | 'queue'/'cancel' | Callback queuing | 'Selected' | 'on'/'off' | Selection state |
| 'ButtonDownFcn' | Function handle | Mouse-click callback | 'SelectionHighlight' | 'on'/'off' | Display of selection handles |
| 'Children' | empty GraphicsPlaceholder array / DataTip object array | Children | 'Tag' | char vector | Object identifier |
| 'Clipping' | 'on'/'off' | Clipping of object to axes limits | 'Type' | 'line' | Type of graphics object |
| 'Color' | RGB triplet | Color of the line | 'UIContextMenu' | NOT RECOMMENDED | NOT RECOMMENDED |
| 'CreateFcn' | Function handle | Creation function | 'UserData' | array | Arbitrary data storage |
| 'DataTipTemplate' | DataTipTemplate object | Data tip content  | 'Visible' | 'on'/'off' | State of visibility |
| 'DeleteFcn' | Function handle |  Deletion function | 'XData' | vector | x values |
| 'DisplayName' | character vector | Legend label | 'XDataMode' | - | - |
| 'HandleVisibility' | 'on'/'off' | Visibility of object handle | 'XDataSource' | - | - |
| 'HitTest' | 'on'/'off' | Response to captured mouse clicks | 'YData' | vector | y values |
| 'Interruptible' | 'on'/'off' | Callback interruption | 'YDataMode' | - | - |
| 'LineJoin' | 'round' / 'miter' / 'champfer' | Style of line corners | 'YDataSource' | - | - |
| 'LineStyle' | char vector | Line Style | 'ZData' | vector | z values |
| 'LineWidth' | positive value | Line Width | 'ZDataMode' | - | - |
| 'Marker' | char array | Marker Style | 'ZDataMode' | 'ZDataSource' | - | - |
| 'MarkerEdgeColor' | RGB triplet | Outer color of markers |  |  |  |

### Advanced Testing
Most of the following functions support **A**uto-**S**olution-**T**racking, a feature that finds the solution whether it is a script or a function. You dont need to give a name so people solving your tasks have a greater freedom. To avoid your own uploaded files from being targeted as the solution, you can give string patterns that will be ignored. Only *.m are considered.

#### mg_keywordsPresent
This function checks for the presence of multiple strings in the solution at once. The first output argument will be false(), if at least one keyword is missing. The second argument will return a string array contatining the missing keywords. Keywords to search for can be defined in a string array. It is based on ML-Grader functions.  
This function supports AST. String patterns that should be avoided in file names can be given as varargin inputs.
```matlab
% Checking for sin, cos and tan
[pass, missing] = mg_keywordsPresent(["sin", "cos", "tan"], "myFile", "anotherFile"); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
msg = mg_multiText("The keyword %s is missing.");
mg_setTestStatus(pass, msg);
% If all keywords were used the test is passed.
% If not all keywords were used the test fails and gives a multiline error.
```
#### mg_keywordsAbsent
This function checks for the absence of multiple strings in the solution at once. The first output argument will be false(), if at least one keyword was used. The second argument will return a string array contatining the used forbidden keywords. Keywords to search for can be defined in a string array. It is based on ML-Grader functions.  
This function supports AST. String patterns that should be avoided in file names can be given as varargin inputs.
```matlab
% Checking for sin, cos and tan
[pass, used] = mg_keywordsAbsent(["sin", "cos", "tan"], "myFile", "anotherFile"); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
msg = mg_multiText("The keyword %s was used.");
mg_setTestStatus(pass, msg);
% If none of the specified keywords were used the test is passed.
% If any of the keywords was used the test fails and gives a multiline error.
```

#### mg_keywordsEither
This function checks for the presence of at least one string of a set in the solution. The first output argument will be false(), if no keyword was used. The second argument will return a string array contatining the used keywords. The third argument will return a string array contatining the unused keywords.  Keywords to search for can be defined in a string array. It is based on ML-Grader functions.  
This function supports AST. String patterns that should be avoided in file names can be given as varargin inputs.
```matlab
% Checking for sin, cos and tan
[pass, used, unused] = mg_keywordsAbsent(["sin", "cos", "tan"], "myFile", "anotherFile"); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
msg_used = mg_multiText("The Keyword %s was used.", used);
msg_unused = mg_multiText("The Keyword %s was not used.", unused);
if pass
  disp(msg_used + msg_unused); % Giving an overview of used and unused terms.
else
  mg_setTestStatus(false(), msg_unused); % The test failed, so used is empty.
end
% If at least one of the specified keywords was used the test is passed.
% If none of the keywords were used the test fails and gives a multiline error.
```

#### mg_solutionContainsExplicit
This function works like [mg_keywordsEither](#mg_keywordsEither). However, it supports regular expressions and ignores comments. The return value is a bool that is true, if at least one regexp was found. Regexp can be given as a string array.  
This function supports AST. String patterns that should be avoided in file names can be given as varargin inputs.

```matlab
% Checking if ode45 was executed with a specified function and any starting values, etc
pass = mg_solutionContainsSpecific(["res.*=.*ode45(.*@func.*)"], "myFile", "anotherFile"); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
```

#### mg_equalsStrictOrder
*Only for script based solutions*  
This functions compares multiple variables to their corresponding reference variables (same name). Upon failure it returns a string array with wrong/missing variables
```matlab
% Checking for variables tick, trick and track
[pass, missing] = mg_equalsStrictOrder(["tick", "trick", "track"]);
msg = mg_multiText("Variable %s is wrong", missing); % Only fails test if pass is false()
mg_setTestStatus(pass, )
```


#### mg_equalsIgnoreOrder
*Only for script based solutions*  
This functions compares a set of solution declared variables against a pool of possible answers. This also allows for checking one variable against different possibilities.  
The outputs contain a pass bool, a string array of wrong and one of duped variables.

```matlab
% Scenario 1:
% Task is to save the zeros of the function x^2-9 to variables n_1 and n_2
[pass, wrong, dupes] = mg_equalsIgnoreOrder(["a_1", "a_2"], -3, 3)
%
% Case 1A:
% Solution puts n_1 = 3 and n_2 = -3
% pass = true(), wrong = [], dupes = []
%
% Case 1B:
% Solution puts n_1 = -3 and n_2 = 3
% pass = true(), wrong = [], dupes = []
%
% Case 1C:
% Solution puts n_1 = -9 and n_2 = 3
% pass = false(), wrong = ["n_1"], dupes = []
%
% Case 1D:
% Solution puts n_1 = 3 and n_2 = 3
% pass = false(), wrong = [], dupes = ["n_2"]
```

```matlab
% Scenario 2:
% Task is to save one zero of the function x^2-9 to the variable n
[pass, wrong, dupes] = mg_equalsIgnoreOrder(["n"], -3, 3)
%
% Case 2A:
% Solution puts n = 3
% pass = true(), wrong = [], dupes = []
%
% Case 2B:
% Solution puts n = -3
% pass = true(), wrong = [], dupes = []
%
% Case 2C:
% Solution puts n = 9
% pass = false(), wrong = ["n"], dupes = []
```

  

#### mg_compArrIgnDim
This function compares arrays regardless of their transposition (it occured multiple times, that solutions would not be recognised, because the transposition was wrong). It also accepts a variable name as input (script based only).

```matlab
mg_setTestStatus( mg_compArrIgnTrans(a, [1,2,3,4]), "The Vector is wrong" );   % Only fails the test on false() inout
mg_setTestStatus( mg_compArrIgnTrans("a", referenceVariables.a), "The Vector is wrong" );   % Only fails the test on false() inout
```

#### mg_varExists
*Only for script based solutions*  
This function checks if variables have been declared by the solution, thus preventing errors in testing. A string array of missing ones is given.

```matlab
[pass, missing] = mg_varExists("alpha", "bravo", "charlie");
mg_setTestStatus(pass, mg_multiText("Variable %s is missing", misisng); % Only fails the test if pass is false()
if alpha ~= 3
  %do stuff
end
```



#### mg_isFunction
This function checks if the solution is a function (defined header, etc.). Result will be true, if the solution is indeed a function.  
This function supports AST. String patterns that should be avoided in file names can be given as varargin inputs.

```matlab
% Checking if solution is a function
pass = mg_isFunction("myFile", "anotherFile"); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
```

#### mg_getSolutionFunction
This function will return the name of a solution function (if there ist any) with fitting in- and output amounts. The second output will tell you the function name, or if there is not the right amount of in- or outputs.  
*The amount for varargin and varargout is -1*  
This function supports AST. String patterns that should be avoided in file names can be given as varargin inputs.

```matlab
% Getting solution function for 3 inputs and varargout
[pass, status] = mg_getSolutionFunction(3, -1, "myFile", "anotherFile"); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
if ~pass
  if status == "in"
    % Inputs dont fit
  elseif status == "out"
    % Outputs dont fit
  end
else
  % do stuff
end
```

#### mg_evalSolutionFunction
This function allows you to call a solution function without knowing its namem thus granting people solving your task additional freedom. You can just call it like a normal function. You will get a false() pass output, if something goes wrong or no solution with fitting in- and outputs was found.  
This function supports AST. **String patterns that should be avoided in file names can be given in form of a string array as the first input argument**.

```matlab
% Checking if solution is a function
[pass,d,e,f] = mg_isFunction(["myFile", "anotherFile"], a, b, c); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
if pass
  if d == 4
    % do stuff
  end
end
```
This function also supports varargin and varargout.



