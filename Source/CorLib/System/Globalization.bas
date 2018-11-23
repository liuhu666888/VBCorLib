Attribute VB_Name = "Globalization"
'The MIT License (MIT)
'Copyright (c) 2015 Kelly Ethridge
'
'Permission is hereby granted, free of charge, to any person obtaining a copy
'of this software and associated documentation files (the "Software"), to deal
'in the Software without restriction, including without limitation the rights to
'use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
'the Software, and to permit persons to whom the Software is furnished to do so,
'subject to the following conditions:
'
'The above copyright notice and this permission notice shall be included in all
'copies or substantial portions of the Software.
'
'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
'INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
'PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
'FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
'OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
'DEALINGS IN THE SOFTWARE.
'
'
' Module: Globalization
'
Option Explicit

Private Const DaysPer100Years       As Long = DaysPer4Years * 25 - 1
Private Const DaysPer400Years       As Long = DaysPer100Years * 4 + 1
Private Const DaysTo10000           As Currency = DaysPer400Years * 25 - 366

Public Const MaxMilliseconds As Currency = DaysTo10000 * MilliSecondsPerDay


Public Enum DatePartPrecision
    YearPart
    MonthPart
    DayPart
    DayOfTheYear
    Complete
End Enum

' We don't want to keep creating these in each CorDateTime object,
' so cache them one time here.
Public DaysToMonthLeapYear()    As Long
Public DaysToMonth()            As Long


Public Sub InitGlobalization()
    DaysToMonth = Cor.NewLongs(0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365)
    DaysToMonthLeapYear = Cor.NewLongs(0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366)
End Sub

Public Function DateToMilliseconds(ByVal d As Date) As Currency
    Const MillisecondsTo1899 As Currency = 59926435200000#
    Dim Days As Currency
    
    If d < 0# Then
        Days = Fix(d * MilliSecondsPerDay - 0.5)
        Days = Days - Modulus(Days, MilliSecondsPerDay) * 2
    Else
        Days = Fix(d * MilliSecondsPerDay + 0.5)
    End If
    
    DateToMilliseconds = Days + MillisecondsTo1899
End Function

Public Function InitDateTime(ByVal dt As CorDateTime, ByRef Time As Variant) As CorDateTime
    Dim Milliseconds As Currency

    Select Case VarType(Time)
        Case vbObject
            If Time Is Nothing Then
                Milliseconds = 0
            ElseIf TypeOf Time Is CorDateTime Then
                Dim t As CorDateTime
                Set t = Time
                Milliseconds = t.TotalMilliseconds
            Else
                Error.Argument Arg_MustBeDateTime
            End If
        Case vbDate
            Milliseconds = DateToMilliseconds(Time)
        Case Else
            Error.Argument Arg_MustBeDateTime
    End Select

    dt.InitFromMilliseconds Milliseconds, UnspecifiedKind

    Set InitDateTime = dt
End Function
