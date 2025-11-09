  library cripto;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  {ShareMem,} System.SysUtils, System.Classes;

{type
  PWordArray = ^TWordArray;
  TWordArray = array[0..MaxInt div SizeOf(Word) - 1] of Word;}

const
  ANSI_ACEITOS : Array[1..197] of char = (' ', '!', '"', '#', '$', '%', '&', #39, '(', ')', '*', '+', ',', '-', '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>','?' , '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '\', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', '', '', '', '', '', '', ' ', '¡', '¢', '£', '¤', '¥', '¦', '§', '¨', '©', 'ª', '«', '¬', '­', '®', '¯', '°', '±', '²', '³', '´', 'µ', '¶', '·', '¸', '¹', 'º', '»', '¼', '½', '¾', '¿', 'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï', 'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', '×', 'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý', 'Þ', 'ß', 'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷', 'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'þ', 'ÿ');
  MINIMO = 13;


{$R *.res}

function TamanhoArquivo(const NomeArquivo: string) : Int64;
var
  F : File of Byte;
  r : Int64;
begin
  try
    r := 0;
    AssignFile(F, NomeArquivo);
    Reset(F);
    r := FileSize(F);
  finally
    try
      CloseFile(F);
    except
    end;{try}
    Result := r;
  end;{try}
end;{function}

Function CodigoNoArrayANSI(caractere : char) : Byte;
var
  i : Integer;
  r : byte;
Begin
  r := 0;
  for i := 1 to Length(ANSI_ACEITOS) do
    if caractere = ANSI_ACEITOS[i] then
    Begin
      r := i;
      break;
    end;{if/for}
  result := r;
End;{function}

Function CaractereNoArrayANSI(codigo : byte) : char;
Begin
  if (codigo = 0) or (codigo > Length(ANSI_ACEITOS)) then
    result := Chr(0){}
  else
    result := ANSI_ACEITOS[codigo];{if}
End;{function}

procedure ZerareArrayChar(var arrayChar : array of char);
var
  I : Integer;
begin
  for I := 0 to Length(arrayChar)-1 do
    arrayChar[I] := #0;{for}
end;{procedure}

procedure StringParaArrayChar(stringOrigem : string; var arrayCharDestino : array of char);
var
  I : Integer;
Begin
  ZerareArrayChar(arrayCharDestino);

  for I := 1 to Length(stringOrigem) do
    arraycharDestino[I-1] := stringOrigem[I];{for}
End;{procedure}

function ArrayCharParaString(arrayCharOrigem : array of char) : string;
var
  s : string;
  I : Integer;
Begin
  s := '';

  for I := 0 to Length(arrayCharOrigem)-1 do
    if Ord(arrayCharOrigem[I]) > 0 then
      s := s + arrayCharOrigem[I];{if/for}

  result := s;
End;{function}

Function Criptografa(texto : string; chave : string; CODIGOMAXIMO : Integer; var erro : string) : string;
var
  cod, calculado, ichave, ajuste, calculoChave, I, tamString : LongInt;
  saida : string;

  Procedure Nucleo;
  var
    I, somatorio : LongInt;
  Begin

    for I := 1 to tamString do
    Begin
      cod := Ord(texto[I]);

      ichave := I mod Length(chave);
      if ichave = 0 then
        ichave := Length(chave);{if}
      ichave := Ord(chave[ichave]);

      if calculoChave > ajuste then
        somatorio := (calculoChave div ajuste) + (calculoChave mod ajuste){}
      else
        somatorio := (ajuste div calculoChave) + (ajuste mod calculoChave);{if}

      if ichave > ajuste then
        somatorio := somatorio + (iChave div ajuste) + (iChave mod ajuste){}
      else
        somatorio := somatorio + (ajuste div iChave) + (ajuste mod iChave);{if}

      if calculoChave > ajuste then
        somatorio := somatorio + (calculoChave div ajuste) + (calculoChave mod ajuste){}
      else
        somatorio := somatorio + (ajuste div calculoChave) + (ajuste mod calculoChave);{if}

      if (somatorio + cod) > CODIGOMAXIMO then
      Begin
        calculado := somatorio - CODIGOMAXIMO + cod;

        if calculado < 1 then
          calculado := somatorio - cod;{if}
      End Else
        calculado := cod + somatorio;{if}

      case StrToInt(Copy(IntToStr(calculado), Length(IntToStr(calculado)), 1)) of
        0, 5 : ajuste := calculado div 2;
        1, 6 : ajuste := (calculado div 2) + (calculado mod 2);
        2, 7 : ajuste := (calculado div iChave) + (iChave div calculado);
        3, 8 : ajuste := (calculado mod iChave) + (iChave mod calculado);
        4, 9 : ajuste := (calculado div iChave) + (iChave div calculado) + (calculado mod iChave) + (iChave mod calculado);
      end;{with}

      if ajuste <= MINIMO then
        ajuste := ajuste + MINIMO{}
      else
      if ajuste > CODIGOMAXIMO then
        ajuste := ajuste - (CODIGOMAXIMO -MINIMO);{if}

      saida := saida + Chr(calculado);
    End;{for}
  End;{procedure}

begin
  erro := '';

  try
    if Length(texto) < 1 then
    Begin
      erro := 'Não há informação para ser Criptografada.';
      Abort;
    End;{if}

    If Length(chave) < 1 Then
      chave := 'a';{if}

    for I := 1 to Length(chave) do
      if Ord(chave[I]) > 255 then
      Begin
        erro := 'Caractere não aceito para chave.';
        Abort;
      End;{if/for}

    tamString := Length(texto);

    calculoChave := 0;
    for I := 1 to Length(chave) do
      if Ord(chave[I]) <= MINIMO then
      Begin
        erro := 'Código de caractere para Chave é inválido.'+#13+chave[I];
        Abort;
      End else
        calculoChave := calculoChave + Ord(chave[I]);{if/for}
    calculoChave := (calculoChave div Length(chave)) + (calculoChave mod Length(chave));

    if calculoChave > CODIGOMAXIMO then
      calculoChave := calculoChave - (CODIGOMAXIMO -MINIMO);{if}

    if calculoChave < MINIMO then
      calculoChave := calculoChave + MINIMO;{if}

    saida := '';

    ajuste := 0;
    for I := 1 to tamString do
      If Ord(texto[I]) > CODIGOMAXIMO then
      Begin
        erro := 'Não suporta caracteres com o código maior que '+IntToStr(CODIGOMAXIMO)+'.'+#13+texto[I];
        Abort;
      End Else
      If Ord(texto[I]) = 0 then
      Begin
        erro := 'Não suporta caracteres com o código 0 (zero) Nulo.';
        Abort;
      End Else
        ajuste := ajuste + Ord(texto[I]);{if..if/for}
    ajuste := (ajuste div tamString) + (ajuste mod tamString) + calculoChave;

    if ajuste <= MINIMO then
      ajuste := ajuste + MINIMO{}
    else
    if ajuste > CODIGOMAXIMO then
      ajuste := ajuste - (CODIGOMAXIMO -MINIMO);{if}

    saida := Chr(ajuste);
    Nucleo;

    result := saida;
  Except
    on E: Exception do
    Begin
      if erro = '' then
        erro := Copy(E.Message, 1, 255);{if}

      result := '';
    End;
  end;{try}
end;{function}

Function DesCriptografa(texto : string; chave : string; CODIGOMAXIMO : Integer; var erro : string) : string;
var
  cod, calculado, ichave, somatorio, ajuste, calculoChave, I, tamString : LongInt;
  saida : string;

  procedure Nucleo;
  var
    I : LongInt;
  Begin
    for I := 1 to tamString do
    Begin
      ichave := I mod Length(chave);
      if ichave = 0 then
        ichave := Length(chave);{if}
      ichave := Ord(chave[ichave]);

      calculado := Ord(texto[I]);

      if calculoChave > ajuste then
        somatorio := (calculoChave div ajuste) + (calculoChave mod ajuste){}
      else
        somatorio := (ajuste div calculoChave) + (ajuste mod calculoChave);{if}

      if ichave > ajuste then
        somatorio := somatorio + (iChave div ajuste) + (iChave mod ajuste){}
      else
        somatorio := somatorio + (ajuste div iChave) + (ajuste mod iChave);{if}

      if calculoChave > ajuste then
        somatorio := somatorio + (calculoChave div ajuste) + (calculoChave mod ajuste){}
      else
        somatorio := somatorio + (ajuste div calculoChave) + (ajuste mod calculoChave);{if}

      case StrToInt(Copy(IntToStr(calculado), Length(IntToStr(calculado)), 1)) of
        0, 5 : ajuste := calculado div 2;
        1, 6 : ajuste := (calculado div 2) + (calculado mod 2);
        2, 7 : ajuste := (calculado div iChave) + (iChave div calculado);
        3, 8 : ajuste := (calculado mod iChave) + (iChave mod calculado);
        4, 9 : ajuste := (calculado div iChave) + (iChave div calculado) + (calculado mod iChave) + (iChave mod calculado);
      end;{with}

      if ajuste <= MINIMO then
        ajuste := ajuste + MINIMO{}
      else
      if ajuste > CODIGOMAXIMO then
        ajuste := ajuste - (CODIGOMAXIMO -MINIMO);{if}

      If calculado - somatorio < 1 then
      Begin
        cod := (somatorio - CODIGOMAXIMO) - calculado;

        if cod < 1 then
          cod := cod * -1;{if}
      End Else
        cod := calculado - somatorio;{if}

      saida := saida + Chr(cod);
    End;{for}
  End;{procedure}

begin
  erro := '';

  try
    if Length(texto) < 1 then
    Begin
      erro := 'Não há informação para ser Descriptografada.';
      Abort;
    End;{if}

    If Length(chave) < 1 Then
      chave := 'a';{if}

    tamString := Length(texto) -1;
    ajuste := Ord(texto[1]);
    texto := Copy(texto, 2, tamString);

    calculoChave := 0;
    for I := 1 to Length(chave) do
      if Ord(chave[I]) = MINIMO then
      Begin
        erro := 'Código de caractere para Chave é inválido.'+#13+chave[I];
        Abort;
      End else
        calculoChave := calculoChave + Ord(chave[I]);{if/for}
    calculoChave := (calculoChave div Length(chave)) + (calculoChave mod Length(chave));

    if calculoChave > CODIGOMAXIMO then
      calculoChave := calculoChave - (CODIGOMAXIMO -MINIMO);{if}

    if calculoChave < MINIMO then
      calculoChave := calculoChave + MINIMO;{if}

    saida := '';

    Nucleo;

    result := saida;
  Except
    on E: Exception do
    Begin
      if erro = '' then
        erro := Copy(E.Message, 1, 255);{if}

      result := '';
    End;
  end;{try}
end;{function}

(*procedure FreeStr(ptr: PAnsiChar); stdcall;
begin
  StrDispose(ptr);
end;{procedure}

procedure FreeWideStr(p: PWideChar); stdcall;
begin
  StrDispose(p);
end;{procedure}*)

Function CriptografaANSI(texto : string; chave : string; var erro: string) : string; stdcall;
var
  cod, calculado, ichave, ajuste, calculoChave,
  I, tamString : LongInt;
  saida : string;

  Procedure Nucleo;
  var
    I, somatorio : LongInt;
  Begin

    for I := 1 to tamString do
    Begin
      cod := CodigoNoArrayANSI(texto[I]);

      ichave := I mod Length(chave);
      if ichave = 0 then
        ichave := Length(chave);{if}
      ichave := CodigoNoArrayANSI(chave[ichave]);

      if calculoChave > ajuste then
        somatorio := (calculoChave div ajuste) + (calculoChave mod ajuste){}
      else
        somatorio := (ajuste div calculoChave) + (ajuste mod calculoChave);{if}

      if ichave > ajuste then
        somatorio := somatorio + (iChave div ajuste) + (iChave mod ajuste){}
      else
        somatorio := somatorio + (ajuste div iChave) + (ajuste mod iChave);{if}

      if calculoChave > ajuste then
        somatorio := somatorio + (calculoChave div ajuste) + (calculoChave mod ajuste){}
      else
        somatorio := somatorio + (ajuste div calculoChave) + (ajuste mod calculoChave);{if}

      if (somatorio + cod) > Length(ANSI_ACEITOS) then
      Begin
        calculado := somatorio - Length(ANSI_ACEITOS) + cod;

        if calculado < 1 then
          calculado := somatorio - cod;{if}
      End Else
        calculado := cod + somatorio;{if}

      case StrToInt(Copy(IntToStr(calculado), Length(IntToStr(calculado)), 1)) of
        0, 5 : ajuste := calculado div 2;
        1, 6 : ajuste := (calculado div 2) + (calculado mod 2);
        2, 7 : ajuste := (calculado div iChave) + (iChave div calculado);
        3, 8 : ajuste := (calculado mod iChave) + (iChave mod calculado);
        4, 9 : ajuste := (calculado div iChave) + (iChave div calculado) + (calculado mod iChave) + (iChave mod calculado);
      end;{with}

      if ajuste <= MINIMO then
        ajuste := ajuste + MINIMO{}
      else
      if ajuste > Length(ANSI_ACEITOS) then
        ajuste := ajuste - (Length(ANSI_ACEITOS) -MINIMO);{if}

      saida := saida + CaractereNoArrayANSI(calculado);
    End;{for}
  End;{procedure}

begin
  erro := '';

  try
    if Length(texto) < 1 then
    Begin
      erro := 'Não há informação para ser Criptografada.';
      Abort;
    End;{if}

    If Length(chave) < 1 Then
      chave := 'a';{if}

    for I := 1 to Length(chave) do
      if Ord(chave[I]) > 255 then
      Begin
        erro := 'Caractere não aceito para chave.';
        Abort;
      End;{if/for}

    tamString := Length(texto);

    calculoChave := 0;
    for I := 1 to Length(chave) do
      if CodigoNoArrayANSI(chave[I]) = 0 then
      Begin
        erro := 'Código de caractere para Chave é inválido.'+#13+chave[I];
        Abort;
      End else
        calculoChave := calculoChave + CodigoNoArrayANSI(chave[I]);{if/for}

    calculoChave := (calculoChave div Length(chave)) + (calculoChave mod Length(chave));

    if calculoChave > Length(ANSI_ACEITOS) then
      calculoChave := calculoChave - (Length(ANSI_ACEITOS) -MINIMO);{if}

    if calculoChave < MINIMO then
      calculoChave := calculoChave + MINIMO;{if}

    saida := '';

    ajuste := 0;
    for I := 1 to tamString do
      if Ord(texto[I]) = 0 then
      Begin
        erro := 'Não suporta caracteres com o código 0 (zero) Nulo.';
        Abort;
      End Else
      if CodigoNoArrayANSI(texto[I]) < 1 Then
      Begin
        erro := 'Caractere não aceito como ANSI. Código '+IntToStr(Ord(texto[I]))+' não é padrão ANSI.'+#13+texto[I];
        Abort;
      End Else
        ajuste := ajuste + CodigoNoArrayANSI(texto[I]);{if..if/for}

    ajuste := (ajuste div tamString) + (ajuste mod tamString) + calculoChave;

    if ajuste <= MINIMO then
      ajuste := ajuste + MINIMO{}
    else
    if ajuste > Length(ANSI_ACEITOS) then
      ajuste := ajuste - (Length(ANSI_ACEITOS) -MINIMO);{if}

    saida := CaractereNoArrayANSI(ajuste);
    Nucleo;

    result := saida;
  Except
    on E: Exception do
    Begin
      if erro = '' then
        erro := 'Erro: ' + E.Message;{if}
      result := '';
    End;
  end;{try}
end;{function}

Function DesCriptografaANSI(texto : string; chave : string; var erro : string) : string; stdcall;
var
  cod, calculado, ichave, somatorio, ajuste, calculoChave : LongInt;
  I, tamString : LongInt;
  saida : string;

  procedure Nucleo;
  var
    I : LongInt;
  Begin
    for I := 1 to tamString do
    Begin
      ichave := I mod Length(chave);
      if ichave = 0 then
        ichave := Length(chave);{if}
      ichave := CodigoNoArrayANSI(chave[ichave]);

      calculado := CodigoNoArrayANSI(texto[I]);

      if calculoChave > ajuste then
        somatorio := (calculoChave div ajuste) + (calculoChave mod ajuste){}
      else
        somatorio := (ajuste div calculoChave) + (ajuste mod calculoChave);{if}

      if ichave > ajuste then
        somatorio := somatorio + (iChave div ajuste) + (iChave mod ajuste){}
      else
        somatorio := somatorio + (ajuste div iChave) + (ajuste mod iChave);{if}

      if calculoChave > ajuste then
        somatorio := somatorio + (calculoChave div ajuste) + (calculoChave mod ajuste){}
      else
        somatorio := somatorio + (ajuste div calculoChave) + (ajuste mod calculoChave);{if}

      case StrToInt(Copy(IntToStr(calculado), Length(IntToStr(calculado)), 1)) of
        0, 5 : ajuste := calculado div 2;
        1, 6 : ajuste := (calculado div 2) + (calculado mod 2);
        2, 7 : ajuste := (calculado div iChave) + (iChave div calculado);
        3, 8 : ajuste := (calculado mod iChave) + (iChave mod calculado);
        4, 9 : ajuste := (calculado div iChave) + (iChave div calculado) + (calculado mod iChave) + (iChave mod calculado);
      end;{with}

      if ajuste <= MINIMO then
        ajuste := ajuste + MINIMO{}
      else
      if ajuste > Length(ANSI_ACEITOS) then
        ajuste := ajuste - (Length(ANSI_ACEITOS) -MINIMO);{if}

      If calculado - somatorio < 1 then
      Begin
        cod := (somatorio - Length(ANSI_ACEITOS)) - calculado;

        if cod < 1 then
          cod := cod * -1;{if}
      End Else
        cod := calculado - somatorio;{if}

      saida := saida + CaractereNoArrayANSI(cod);
    End;{for}
  End;{procedure}

begin
  erro := '';

  try
    if Length(texto) < 1 then
    Begin
      erro := 'Não há informação para ser Descriptografada.';
      Abort;
    End;{if}

    If Length(chave) < 1 Then
      chave := 'a';{if}

    tamString := Length(texto) -1;
    ajuste := CodigoNoArrayANSI(texto[1]);
    texto := Copy(texto, 2, tamString);

    calculoChave := 0;
    for I := 1 to Length(chave) do
      if CodigoNoArrayANSI(chave[I]) = 0 then
      Begin
        erro := 'Código de caractere para Chave é inválido.'+#13+chave[I];
        Abort;
      End else
        calculoChave := calculoChave + CodigoNoArrayANSI(chave[I]);{if/for}
    calculoChave := (calculoChave div Length(chave)) + (calculoChave mod Length(chave));

    if calculoChave > Length(ANSI_ACEITOS) then
      calculoChave := calculoChave - (Length(ANSI_ACEITOS) -MINIMO);{if}

    if calculoChave < MINIMO then
      calculoChave := calculoChave + MINIMO;{if}

    saida := '';

    Nucleo;

    result := saida;
  Except
    on E: Exception do
    Begin
      if erro = '' then
        erro := Copy(E.Message, 1, 255);{if}
      result := '';
    End;
  end;{try}
end;{function}

function CriptografaUTF8(texto: string; chave: string; var erro: string): string; stdcall;
var
  sErro: string;
begin

  sErro := '';

  try
    result := Criptografa(texto, string(chave), 255, sErro);

    if sErro <> '' then
      erro := sErro;
  except
    on E: Exception do
    begin
      erro := 'Erro interno: ' + E.Message;
      result := '';
    end;
  end;
end;{function}

Function DesCriptografaUTF8(texto : string; chave : string; var erro: string) : string; stdcall;
var
  i : Integer;
begin
  erro := '';

  try
    for I := 1 to Length(texto) do
      if Ord(texto[I]) > 255 then
      Begin
        erro := 'Caractere não aceito para UTF8.';
        abort;
      End;{if}

    result := DesCriptografa(texto, string(chave), 255, erro);

  except
    on E: Exception do
    begin
      erro := 'Erro interno: ' + E.Message;
      result := '';
    end;
  end;
End;{function}

Function CriptografaUTF16(texto : string; chave : string; var erro: string) : string; stdcall;
var
  sErro: string;
  s : string;
begin
  sErro := '';

  try
    s := Criptografa(texto, string(chave), 65535, sErro);

    if sErro <> '' then
      erro := sErro;

    result := s;
  except
    on E: Exception do
    begin
      erro := 'Erro interno: ' + E.Message;
      result := '';
    end;
  end;
End;{function}

Function DesCriptografaUTF16(texto : string; chave : string; var erro: string) : string; stdcall;
var
  sErro: string;
begin
  sErro := '';

  try
    result := DesCriptografa(texto, string(chave), 65535, sErro);

    if sErro <> '' then
      erro := sErro;
  except
    on E: Exception do
    begin
      erro := ((string('Erro interno: ' + E.Message)));
      result := '';
    end;
  end;
End;{function}

Procedure StringParaArrayInteiro(texto : string; var saidaInt : Array of Word); stdcall;
var
  I : LongInt;
Begin

  for I := 1 to Length(texto) do
    saidaInt[I-1] := Ord(texto[I]);{for}
End;{procedure}

function ArrayInteiroParaString(saidaInt : Array of Word) : String; stdcall;
var
  I : LongInt;
  texto : string;
Begin
  texto := '';

  for I := 0 to Length(saidaInt)-1 do
    if saidaInt[I] >= 0 then
      texto := texto + Chr(saidaInt[I]);{if/for}

  result := texto;
End;{procedure}

Function CriptografiaAssimetrica(texto : string; chave : string; var erro : string; SaidaTamanhoFixo : Word = 0) : string; stdcall;
const
  CARACTEREMAXIMO = 255;
var
  I, tamTexto, cod, calculado, ichave, somatorio, ajuste,
  calculoTexto, calculoChave : LongInt;
  saida : string;

  procedure Nucleo;
  var
    I : Integer;
  Begin
    for I := 1 to tamTexto do
    Begin
      ichave := I mod Length(chave);
      if ichave = 0 then
        ichave := Length(chave);{if}
      ichave := Ord(chave[ichave]);

      cod := Ord(texto[I]);

      somatorio :=
      (calculoTexto div iChave) + (calculoTexto mod iChave) +
      (iChave div calculoTexto) + (iChave mod calculoTexto) +
      (calculoChave div ajuste) + (calculoChave mod ajuste) +
      (ajuste div calculoChave) + (ajuste mod calculoChave) +
      (iChave div ajuste) + (iChave mod ajuste) +
      (ajuste div iChave) + (ajuste mod iChave);

      calculado := cod + somatorio;

      if calculado <= MINIMO then
        calculado := calculado + MINIMO{}
      else
      while calculado > CARACTEREMAXIMO do
        calculado := calculado - (CARACTEREMAXIMO -MINIMO);{if}

      saida := saida + Chr(calculado);

      ajuste := (calculado div iChave) + (iChave div calculado) +
                (calculado mod iChave) + (iChave mod calculado) + I;

      if ajuste <= MINIMO then
        ajuste := ajuste + MINIMO{}
      else
      while ajuste > CARACTEREMAXIMO do
        ajuste := ajuste - (CARACTEREMAXIMO -MINIMO);{if}
    End;{for}
  End;{procedure}

Begin
  erro := '';
  saida := '';

  try
    if Length(texto) > 0 then
    Begin
      If Length(chave) < 1 Then
        chave := 'a';{if}

      for I := 1 to Length(chave) do
        if Ord(chave[I]) > 255 then
        Begin
          erro := 'Caractere não aceito para chave.';
          Abort;
        End;{if/for}

      calculoChave := 0;
      for I := 1 to Length(chave) do
        if Ord(chave[I]) <= MINIMO then
        Begin
          erro := 'Código de caractere para Chave é inválido.'+#13+chave[I];
          Abort;
        End else
          calculoChave := calculoChave + Ord(chave[I]);{if/for}
      calculoChave := (calculoChave div Length(chave)) + (calculoChave mod Length(chave));

      if calculoChave < MINIMO then
        calculoChave := calculoChave + MINIMO;{if}

      If SaidaTamanhoFixo > 0 then
      Begin
        while Length(texto) < SaidaTamanhoFixo do
          texto := texto + texto;{do}

        texto := Copy(texto, 1, SaidaTamanhoFixo);
      End;{if}

      tamTexto := Length(texto);

      calculoTexto := 0;
      for I := 1 to tamTexto do
        If Ord(texto[I]) = 0 then
        Begin
          erro := 'Não suporta caracteres com o código 0 (zero) Nulo.';
          Abort;
        End Else
          calculoTexto := calculoTexto + Ord(texto[I]);{if/for}
      calculoTexto := (calculoTexto div tamTexto) + (calculoTexto mod tamTexto);

       ajuste := calculoTexto + calculoChave;

      if ajuste <= MINIMO then
        ajuste := ajuste + MINIMO;{if}

      Nucleo;
    End;{if}

    result := saida;
  Except
    on E: Exception do
    Begin
      if erro = '' then
        erro := Copy(E.Message, 1, 255);{if}

      result := '';
    End;
  end;{try}
End;{function}

exports
  {FreeStr,
  FreeWideStr,}
  CriptografaANSI,
  DesCriptografaANSI,
  CriptografaUTF8,
  DesCriptografaUTF8,
  CriptografaUTF16,
  DesCriptografaUTF16,
  CriptografiaAssimetrica,
  StringParaArrayInteiro,
  ArrayInteiroParaString;

begin

(* Em C#

[DllImport("Cripto.dll", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi)]
public static extern IntPtr CriptografaANSI(string texto, string chave, out IntPtr erro);

[DllImport("Cripto.dll", CallingConvention = CallingConvention.StdCall)]
public static extern void FreeStr(IntPtr ptr);

IntPtr erro;
IntPtr resultadoPtr = CriptografaANSI("mensagem", "chave", out erro);

if (erro != IntPtr.Zero)
{
  string sErro = Marshal.PtrToStringAnsi(erro);
  Console.WriteLine("Erro: " + sErro);
  FreeStr(erro);
}

string resultado = Marshal.PtrToStringAnsi(resultadoPtr);

*)
end.
