# GraderPlus - A library for writing test code in MATLAB®-Grader
GraderPlus is a collection of standalone functions that can be integrated into MATLAB®-Grader tasks to improve the writing of test code. It allows for more diverse tests, easier test creation. GraderPlus empowers the task creator to create problems that allow more diverse solutions. 
Please keep in mind that this library is provided "as is" without warranty of any kind.  
   
If you are missing something or have ideas for improvements, get in touch, write an [eMail](mailto:david.kosfelder@tu-dortmund.de).

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
The GraderPlus library code was developed during the funded QVM project "Feedback!" of the EiP Team at the faculty BCI at TU Dortmund University in Germany. 

The main features of GraderPlus are:
* Writing complex tests by using small helper functions.
* Share variables between environments. (the solution, and each tests are in their own MATLAB environment)
* Write test-code to check for correct content in plots.

### Integration
Every file works standalone and provides a specific functionality to test MATLAB®-Grader tasks. The files that shall be used in the test code must be uploaded as an additional file in the web-frontend of MATLAB®-Grader. Afterwards, you can call the library functions in the test code of the MATLAB®-Grader task.

### Function and script based solutions
The MATLAB®-Grader environment differentiates between functions and scripts as solutions. Therefore, some of the functions only work in script other in function environments.

### Function Naming
All names of the provided functions are prefixed with "mg_". This is important as we internally use reflection to search for functions that were provided in the solution code by the student (see mg_isFunction.m). The functions prefixed with "mg_" are exclude in the default case. If you use helper functions that shall not interfere with the reflection of the solution code you can either prefix your functions with "mg_" or you can use an overload of the provided functions that extends the filter functionality and by this allows to also exclude your internal functions.

## Functions
The remaining text will describe the functions provided by GraderPlus in more detail.

### Failing a test with a user-generated message 

You can fail a test by generating an error. GraderPlus contains two methods, one that uses the MATLAB internal function error() to fail a test and another to generate a multiline string with repeats an error messages for multiple occurences.

#### mg_setTestStatus
Wrapper that changes a test status to fail if the condition is false and outputs the given error text.
In the following case it does nothing:
```matlab
mg_setTestSatus(true(), "some text");
```
In this case it fails with a test containing the message "some text".
```matlab
mg_setTestSatus(false(), "some text");
```
#### mg_multiText
Returns a formatted string that is duplicated several times. The base string may contain placeholders like "%s" which will be replaced by the input strings in the second argument. The base string will be repeated once for every element of the second argument on a new line.
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
The following functions allow you to share variables between tests. So they can be generated in a test one and be recalled in a later test, e.g. test 2. The tests are executed in the order of their definition. 

#### mg_writeSharedVariables
This functions allows you to store Variables of a test and make them able to be recalled later. It has to be executed in a test before the values can be loaded in another one. It works simmilar to the save() function. The output returns true(), if the saving operation was successful.
```matlab
mg_writeSharedVariables(); % Saves all variables declared in the current test
mg_writeSharedVariables("a", "b"); % Only saves variables a and b
```

#### mg_loadSharedVariables
This functions allows you to load stored Variables. If used without calling mg_writeSharedVariables first it will return false.
```matlab
mg_loadSharedVariables(); % Loads all previously stored variables
mg_loadSharedVariables("a", "b"); % Only loads variables a and b
```

### Graphic Evalutaion
These functions grab information from the graph that is drawn by a student solution.

#### mg_plotExists
Returns a bool that indicates if a plot was created by the solution code.
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
|xLimits|1x2 vector|Limit vector [min max] of x axis|lineCount|int|Amount of drawn lines/graphs|
|yLimits|1x2 vector|Limit vector [min max] of y axis|legend|1x1 legend|Legend object|
|zLimits|1x2 vector|Limit vector [min max] of z axis|legendAvailable|bool|true() when legend exists|
|xScale|string|Information about the x axis scale|legendTitle|string|Title of legend as string|
|yScale|string|Information about the y axis scale|legendText|1xn string|Array of names used in the legend. Order is depending on the solution|

#### mg_isCurveInPlot

This function allows you to search for a specified line in a plot that has been drawn by the solution code. Multiple lines are supported, but you can only search for one line at a time. The returned value is a bool that is true, if all required properties fit to at least one line in the graph. Only the properties that shall be checked need to be specified. Specification works via key-value arguments as shown in the following example. An even number of inputs and at least two arguments must be given. For more information check out the [line](https://www.mathworks.com/help/matlab/ref/matlab.graphics.primitive.line-properties.html) object.
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
This function checks for the presence of multiple strings in the solution code. The input argument is a string array that contains the keywords that shall be used. The first output argument is false, if at least one keyword is missing. The second output argument is a string array contatining the missing keywords.
This function supports AST. Filename patterns that should be avoided during reflection can be given as varargin inputs.
```matlab
% Checking for sin, cos and tan
[pass, missing] = mg_keywordsPresent(["sin", "cos", "tan"], "myFile", "anotherFile"); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
msg = mg_multiText("The keyword %s is missing.", used);
mg_setTestStatus(pass, msg);
% If all keywords were used the test is passed.
% If not all keywords were used the test fails and gives a multiline error.
```
#### mg_keywordsAbsent
This function checks for the absence of multiple strings in the solution code. The input argument is a string array that contains the keywords that shall not be used. The first output argument is false, if at least one keyword has been used and true otherwise. The second argument returns a string array contatining the used forbidden keywords.  
This function supports AST. Filename patterns that should be avoided during reflection can be given as varargin inputs.
```matlab
% Checking for sin, cos and tan
[pass, used] = mg_keywordsAbsent(["sin", "cos", "tan"], "myFile", "anotherFile"); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
msg = mg_multiText("The keyword %s was used.", used);
mg_setTestStatus(pass, msg);
% If none of the specified keywords were used the test is passed.
% If any of the keywords was used the test fails and gives a multiline error.
```

#### mg_keywordsEither
This function checks for the presence of at least one string of a set in the solution code. The input argument is a string array that contains the keywords that contains at least one keyword that is also part of the solution code. The first output argument is false, if no keyword was used. The second output argument is a string array contatining the keywords used in the solution code. The third argument is a string array containing the keywords unused in the solution code. 
This function supports AST. Filename patterns that should be avoided during reflection can be given as varargin inputs.
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
This function works like [mg_keywordsEither](#mg_keywordsEither). However, it supports regular expressions and ignores comments in the solution code. The return value is a bool that is true, if at least one regexp was found. Regexp can be given as a string array.  
This function supports AST. Filename patterns that should be avoided during reflection can be given as varargin inputs.

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
This functions compares a set of solution declared variables against a pool of possible answers. In one use-case this also allows to check one variable against a set of correct values.  
The outputs contains boolean flag, a string array of wrong and one of duped variables.

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
This function compares arrays regardless of their transposition. It also accepts a variable name as input (script based only). By this the tasks does not need to specifiy correct transposition of vectors anymore.

```matlab
mg_setTestStatus( mg_compArrIgnTrans(a, [1,2,3,4]), "The Vector is wrong" );   % Only fails the test on false() inout
mg_setTestStatus( mg_compArrIgnTrans("a", referenceVariables.a), "The Vector is wrong" );   % Only fails the test on false() inout
```

#### mg_varExists
*Only for script based solutions*  
This function checks if variables have been declared in the solution code. As a first step, this prevents errors in testing code due to not declared variables. It returns a boolean flag if the check has pass and in case of pass=false it missing contains a list of the variable names that are not declared.

```matlab
[pass, missing] = mg_varExists("alpha", "bravo", "charlie");
mg_setTestStatus(pass, mg_multiText("Variable %s is missing", misisng); % Only fails the test if pass is false()
if alpha ~= 3
  %do stuff
end
```



#### mg_isFunction
This function checks if the solution is a function (defined header, etc.). Result will be true, if the solution is indeed a function.  
This function supports AST. Filename patterns that should be avoided during reflection can be given as varargin inputs.

```matlab
% Checking if solution is a function
pass = mg_isFunction("myFile", "anotherFile"); % myFile.m, anotherFile.m and files like myFileIsAwesme.m will be ignored.
```

#### mg_getSolutionFunction
This function will return the name of a solution function (if there ist any) with fitting in- and output amounts. The second output will tell you the function name, or if there is not the right amount of in- or outputs.  
*The amount for varargin and varargout is -1*  
This function supports AST. Filename patterns that should be avoided during reflection can be given as varargin inputs.

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
This function allows you to call a solution function without knowing its name thus granting people solving your task additional freedom. You can just call it like a normal function. You will get a false() pass output, if something goes wrong or no solution with fitting in- and outputs was found.  
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



