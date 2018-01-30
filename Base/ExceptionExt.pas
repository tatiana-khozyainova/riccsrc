unit ExceptionExt;

interface
uses
  SysUtils;
type

  ExceptionClass = class of Exception;

  EArgumentOutOfRangeException = class(Exception)
  end;

  ///  Класс исключений
  ///  вызов метода запрещён
  ECallProhibited = class (Exception)
    constructor Create;
  end;

  ///  Класс исключений
  ///  метод ещё не реализован
  ENotImplemented = class (Exception)
  public
    constructor Create;
  end;

  ///  Класс исключений
  ///  повторное назначение свойства объекту запрещено
  ///  испоьзуется для задания неизменных (readonly) свойств
  ///  классов.
  EReadonlyResetProhibited = class (Exception)
    constructor Create;
  end;


  ///  Класс исключений
  ///  любой недопустимой операции
  EInvalidOperation = class (Exception)
    constructor Create;overload;
    constructor Create(const Message : String);overload;
  end;

  ///
  ///  Тест ещё не реализован
  ///
  ETestNotCompleted = class (Exception)
    constructor Create;
  end;

  ///
  ///  Исключение, содержащее вложенное исключение
  ///
  EChainedException = class(Exception)
  private
    FInnerException : Exception;
  public
    constructor Create(InnerException:Exception; Message : String);
    property InnerException : Exception read FInnerException;
  end;

  ///
  ///  Ошибка в контексте другого потока
  ///
  EConcurencyException = class (EChainedException)
  private
    FThreadMessage : String;
    function GetThreadException : Exception;
  public
    constructor Create(ThreadException : Exception; Message : String);
    property ThreadException : Exception read GetThreadException;
    property ThreadMessage : String read FThreadMessage;
  end;

  ///
  ///  Базовый класс пользовательских исключений
  ///
  EApplicationException = class (EChainedException)
  private
    FErrorCode : Integer;
  public
    constructor Create(Message : String);overload;
    constructor Create(InnerException:Exception; Message : String);overload;
     constructor Create(InnerException:Exception; Message : String; ErrorCode : Integer);overload;
    property ErrorCode : Integer read FErrorCode;
  end;

  ///
  ///  Диагностирует ошибку входа в прогамму
  ELogonFailed = class (EChainedException)
    constructor Create(InnerException : Exception);
  end;

  TExceptionsFactory = class
  public
    class procedure RaiseNotImplemented;overload;
    class procedure RaiseCallProhibited;overload;
    class procedure RaiseReadonlyResetProhibited;overload;
    class procedure RaiseInvalidOperation;overload;
    class procedure RaiseInvalidOperation(const Message : string);overload;
    class procedure RaiseTestNotCompleted;overload;
    class procedure RaiseConcurencyException(InnerException : Exception; Message : String);
    class procedure RaiseLogonFailedException(InnerException : Exception);
    class procedure RaiseOutOfRange;overload;
    class procedure RaiseOutOfRange(const Message : String);overload;
    class procedure RaiseApplicationException(InnerException : Exception; Message : String; ErrorCode : Integer);
  end;

implementation

{ ENotImplemented }

constructor ENotImplemented.Create;
begin
  Self.Message := 'Метод ещё не реализован!';
end;

{ ECallProhibited }

constructor ECallProhibited.Create;
begin
  Message := 'Вызов этого метода запрещён';
end;

{ EReadonlyResetProhibited }

constructor EReadonlyResetProhibited.Create;
begin
  Message := 'Допускается только однократное присвоение значения!';
end;

{ TExcpetionsFactory }

class procedure TExceptionsFactory.RaiseApplicationException(
  InnerException: Exception; Message: String; ErrorCode : Integer);
begin
  raise EApplicationException.Create(InnerException, Message, ErrorCode);
end;

class procedure TExceptionsFactory.RaiseCallProhibited;
begin
  raise ECallProhibited.Create;
end;

class procedure TExceptionsFactory.RaiseConcurencyException(
  InnerException: Exception; Message : String);
begin
  raise EConcurencyException.Create(InnerException, Message);
end;

class procedure TExceptionsFactory.RaiseInvalidOperation(const Message: string);
begin
  raise EInvalidOperation.Create(Message);
end;

class procedure TExceptionsFactory.RaiseInvalidOperation;
begin
  raise EInvalidOperation.Create;
end;

class procedure TExceptionsFactory.RaiseLogonFailedException(
  InnerException: Exception);
begin
  raise ELogonFailed.Create(InnerException);
end;

class procedure TExceptionsFactory.RaiseNotImplemented;
begin
  raise ENotImplemented.Create;
end;

class procedure TExceptionsFactory.RaiseOutOfRange;
begin
  RaiseOutOfRange('Значение аргумента выходит за границы допустимых значений.');
end;

class procedure TExceptionsFactory.RaiseOutOfRange(const Message: String);
begin
  raise EArgumentOutOfRangeException.Create(Message);
end;

class procedure TExceptionsFactory.RaiseReadonlyResetProhibited;
begin
  raise EReadonlyResetProhibited.Create;
end;

class procedure TExceptionsFactory.RaiseTestNotCompleted;
begin
  raise ETestNotCompleted.Create;
end;

{ EInvalidOperation }

constructor EInvalidOperation.Create;
begin
  Create('Операция недопустима в данном контексте или с указанными параметрами.');
end;

constructor EInvalidOperation.Create(const Message: String);
begin
  inherited Create(Message);
end;

{ ETestNotCompleted }

constructor ETestNotCompleted.Create;
begin
  Message := 'Тест ещё не реализован!';
end;

{ EConcurencyException }

constructor EConcurencyException.Create(ThreadException: Exception; Message : String);
begin
  inherited Create(ThreadException, 'Исключение в контексте другого потока.');
  Self.FThreadMessage := Message;
end;

function EConcurencyException.GetThreadException: Exception;
begin
  Result := Self.InnerException;
end;

{ EChainedException }

constructor EChainedException.Create(InnerException: Exception;
  Message: String);
begin
  inherited Create(Message);
  FInnerException := InnerException;
end;

{ ENoLogon }

constructor ELogonFailed.Create(InnerException: Exception);
begin
  inherited Create(InnerException, 'Вход в систему закончился неудачей.');
end;

{ EApplicationException }

constructor EApplicationException.Create(Message: String);
begin
  inherited Create(nil, Message);
end;

constructor EApplicationException.Create(InnerException: Exception;
  Message: String);
begin
  inherited;
end;

constructor EApplicationException.Create(InnerException: Exception;
  Message: String; ErrorCode: Integer);
begin
  inherited Create(InnerException, Message);
  FErrorCode := ErrorCode;
end;


end.
