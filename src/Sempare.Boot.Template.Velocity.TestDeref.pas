(*%****************************************************************************
 *  ___                                             ___               _       *
 * / __|  ___   _ __    _ __   __ _   _ _   ___    | _ )  ___   ___  | |_     *
 * \__ \ / -_) | '  \  | '_ \ / _` | | '_| / -_)   | _ \ / _ \ / _ \ |  _|    *
 * |___/ \___| |_|_|_| | .__/ \__,_| |_|   \___|   |___/ \___/ \___/  \__|    *
 *                     |_|                                                    *
 ******************************************************************************
 *                                                                            *
 *                        VELOCITY TEMPLATE ENGINE                            *
 *                                                                            *
 *                                                                            *
 *          https://www.github.com/sempare/sempare.boot.velocity.oss          *
 ******************************************************************************
 *                                                                            *
 * Copyright (c) 2019 Sempare Limited,                                        *
 *                    Conrad Vermeulen <conrad.vermeulen@gmail.com>           *
 *                                                                            *
 * Contact: info@sempare.ltd                                                  *
 *                                                                            *
 * Licensed under the Apache License, Version 2.0 (the "License");            *
 * you may not use this file except in compliance with the License.           *
 * You may obtain a copy of the License at                                    *
 *                                                                            *
 *   http://www.apache.org/licenses/LICENSE-2.0                               *
 *                                                                            *
 * Unless required by applicable law or agreed to in writing, software        *
 * distributed under the License is distributed on an "AS IS" BASIS,          *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   *
 * See the License for the specific language governing permissions and        *
 * limitations under the License.                                             *
 *                                                                            *
 ****************************************************************************%*)
unit Sempare.Boot.Template.Velocity.TestDeref;

interface

uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestVelocityDeref = class
  private
    procedure Test<T>(const AValue: T; const AExpect: string; const ATemplate: string);
  public
    [Test]
    procedure TestExprDrefef;
    [Test]
    procedure TestSimpleDrefef;
    [Test]
    procedure TestWith;
  end;

implementation

uses
  SysUtils,
  System.Rtti,
  System.Json,
  System.Generics.Collections,
  System.Classes,
  Sempare.Boot.Template.Velocity,
  Sempare.Boot.Template.Velocity.Rtti,
  Sempare.Boot.Template.Velocity.AST,
  Sempare.Boot.Template.Velocity.Evaluate,
  Sempare.Boot.Template.Velocity.Common,
  Sempare.Boot.Template.Velocity.PrettyPrint,
  Sempare.Boot.Template.Velocity.Lexer;

{ TTestVelocity }

procedure TTestVelocityDeref.Test<T>(const AValue: T; const AExpect: string; const ATemplate: string);
var
  c: IVelocityTemplate;
begin
  c := Velocity.parse(ATemplate);
  Assert.AreEqual(AExpect, Velocity.Eval(c, AValue));
end;

type
  TExprDeref = record
    a: record
      b: record
        abcdef: string;
        abcghi: string;
      end;
    end;
  end;

procedure TTestVelocityDeref.TestExprDrefef;
var
  rec: TExprDeref;
begin
  rec.a.b.abcdef := '123';
  rec.a.b.abcghi := '456';

  Test(rec, '''before  123 after ''', '''before <% suffix := ''def'' %> <% a.b[''abc'' + suffix] %> after ''');
end;

procedure TTestVelocityDeref.TestSimpleDrefef;
begin
  Velocity.parse('before <% a.b %> after ');
end;

procedure TTestVelocityDeref.TestWith;
var
  rec: TExprDeref;
begin
  rec.a.b.abcdef := '123';
  rec.a.b.abcghi := '456';
  Test(rec, '123456', '<% with a.b %><% abcdef %><% abcghi %><%end%>');

end;

initialization

TDUnitX.RegisterTestFixture(TTestVelocityDeref);

end.
