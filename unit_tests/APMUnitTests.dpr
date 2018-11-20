//Copyright 2018 Oamaru Group Inc.
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
program APMUnitTests;
{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  APMUserTest in 'APMUserTest.pas',
  APM.Metadata in '..\apm_client\APM.Metadata.pas',
  DefaultInstances in 'DefaultInstances.pas',
  APMSystemTest in 'APMSystemTest.pas',
  APMProcessTest in 'APMProcessTest.pas',
  APMAgentTest in 'APMAgentTest.pas',
  APMFrameworkTest in 'APMFrameworkTest.pas',
  APMLanguageTest in 'APMLanguageTest.pas',
  APMRuntimeTest in 'APMRuntimeTest.pas',
  APMServiceTest in 'APMServiceTest.pas',
  APMMetadataTest in 'APMMetadataTest.pas',
  APM.Transaction in '..\apm_client\APM.Transaction.pas',
  APMTransactionTest in 'APMTransactionTest.pas',
  APM.Error in '..\apm_client\APM.Error.pas',
  APMExceptionTest in 'APMExceptionTest.pas',
  APMLogTest in 'APMLogTest.pas',
  APMErrorTest in 'APMErrorTest.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.













