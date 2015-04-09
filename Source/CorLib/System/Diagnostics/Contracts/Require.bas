Attribute VB_Name = "Require"
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
' Module: Require
'

''
' Provides argument validation methods.
'
Option Explicit

Public Sub That(ByVal Assertion As Boolean, Optional ByVal Message As ResourceString = Argument_Exception, Optional ByVal Parameter As ResourceString = Parameter_None)
    If Not Assertion Then
        ThrowHelper.Argument Message, Parameter
    End If
End Sub

Public Sub Range(ByVal Assertion As Boolean, Optional ByVal Parameter As ResourceString = Parameter_None, Optional ByVal Message As ResourceString = ArgumentOutOfRange_Exception)
    If Not Assertion Then
        ThrowHelper.ArgumentOutOfRange Parameter, Message
    End If
End Sub

Public Sub NotNothing(ByVal Object As Object, Optional ByVal Parameter As ResourceString = Parameter_None, Optional ByVal Message As ResourceString = ArgumentNull_Exception)
    If Object Is Nothing Then
        ThrowHelper.ArgumentNull Parameter, Message
    End If
End Sub

Public Sub NotNullArray(ByRef Arr As Variant, Optional ByVal Parameter As ResourceString = Parameter_Arr, Optional ByVal Message As ResourceString = ArgumentNull_Array)
    Require.NotNullArrayPtr ArrayPointer(Arr), Parameter, Message
End Sub

Public Sub NotNullArrayPtr(ByVal ArrayPtr As Long, Optional ByVal Parameter As ResourceString = Parameter_Arr, Optional ByVal Message As ResourceString = ArgumentNull_Array)
    If ArrayPtr = vbNullPtr Then
        ThrowHelper.ArgumentNull Parameter, Message
    End If
End Sub

Public Sub SingleDimensionArray(ByRef Arr As Variant, Optional ByVal Parameter As ResourceString = Parameter_Arr)
    Require.SingleDimensionArrayPtr ArrayPointer(Arr), Parameter
End Sub

Public Sub SingleDimensionArrayPtr(ByVal ArrayPtr As Long, Optional ByVal Parameter As ResourceString = Parameter_Arr)
    If SafeArrayGetDim(ArrayPtr) > 1 Then
        Throw Cor.NewArgumentException(Environment.GetResourceString(Rank_MultiDimNotSupported))
    End If
End Sub

Public Sub NotNullSingleDimensionArray(ByRef Arr As Variant, Optional ByVal Parameter As ResourceString = Parameter_Arr, Optional ByVal Message As ResourceString = ArgumentNull_Array)
    NotNullSingleDimensionArrayPtr ArrayPointer(Arr), Parameter, Message
End Sub

Public Sub NotNullSingleDimensionArrayPtr(ByVal ArrayPtr As Long, Optional ByVal Parameter As ResourceString = Parameter_Arr, Optional ByVal Message As ResourceString = ArgumentNull_Array)
    Require.NotNullArrayPtr ArrayPtr, Parameter, Message
    Require.SingleDimensionArrayPtr ArrayPtr, Parameter
End Sub

Public Sub SingleRankArray(ByRef Arr As Variant)
    SingleRankArrayPtr ArrayPointer(Arr)
End Sub

Public Sub SingleRankArrayPtr(ByVal ArrayPtr As Long)
    If SafeArrayGetDim(ArrayPtr) > 1 Then
        ThrowHelper.MultiDimensionNotSupported
    End If
End Sub

Public Sub NotNullSingleRankArray(ByRef Arr As Variant, Optional ByVal Parameter As ResourceString = Parameter_Arr, Optional ByVal Message As ResourceString = ArgumentNull_Array)
    NotNullSingleRankArrayPtr ArrayPointer(Arr), Parameter, Message
End Sub

Public Sub NotNullSingleRankArrayPtr(ByVal ArrayPtr As Long, Optional ByVal Parameter As ResourceString = Parameter_Arr, Optional ByVal Message As ResourceString = ArgumentNull_Array)
    Require.NotNullArrayPtr ArrayPtr, Parameter, Message
    Require.SingleRankArrayPtr ArrayPtr
End Sub
