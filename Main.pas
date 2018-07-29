unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects,
  FMX.Printer;

type
  TMetrics = class
  private

  public
    Top: single;
    Ascender: single;
    Base: single;
    Caps: single;
    Descender: single;
    Bottom: single;
    constructor Create(const Font: TFont);
    procedure Read(Font: TFont);
  end;

  TForm3 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Layout1: TLayout;
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure PaintBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure ListBox1KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    FMetrics: TMetrics;
    Font: TFont;
    procedure DrawGuide(Canvas: TCanvas; const ClipRect: TRectF;
      const Opacity: single = 1);
    function fetchMetrics: TMetrics;
    procedure DisplayMetrics;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.Edit1Change(Sender: TObject);
var m: TMetrics;
begin

end;

procedure TForm3.Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  case KeyChar of
    '0'..'9':;
    '.':;
    #8:;
    #0:;
    else
    begin
      key := 0;
      keyChar := #0;
    end;
  end;
end;

procedure TForm3.Edit1KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  DisplayMetrics;
end;

procedure TForm3.DisplayMetrics;
var m: TMetrics;

  function DispValue(const value: single): string ;
  begin
    result := floattostrf((value / PaintBox1.Canvas.Scale), TFloatFormat.ffFixed, 8, 1);
  end;

begin
  Font.Size := strToFloatDef(Edit1.Text, 11);
  m := fetchmetrics;
  PaintBox1.Repaint;
  Label10.Text := DispValue(m.Top);
  Label11.Text := DispValue(m.Ascender);
  Label12.Text := DispValue(m.Base);
  Label13.Text := DispValue(m.Descender);
  Label14.Text := DispValue(m.Bottom);
  Label16.Text := DispValue(m.Caps);
  m.Free;
  PaintBox1.Repaint;
end;

function TForm3.fetchMetrics: TMetrics;
begin
  result := TMetrics.Create(Font);
end;

procedure TForm3.DrawGuide(Canvas: TCanvas; const ClipRect: TRectF;
  const Opacity: single = 1);

const long: single = 10;
var p, d: TPointF;

begin
  Canvas.Stroke.Color := TAlphaColors.Gray;
  Canvas.Stroke.Kind := TBrushKind.Solid;;
  Canvas.Stroke.Thickness := 2;
    begin
      p.X := ClipRect.Left + long;
      p.Y := ClipRect.Top;
      Canvas.DrawLine(ClipRect.TopLeft, p, Opacity);
      p.X := ClipRect.Left;
      p.Y := ClipRect.Top + long;
      Canvas.DrawLine(ClipRect.TopLeft, p, Opacity);
    end;
    begin
      p.X := ClipRect.Right - long;
      p.Y := ClipRect.Bottom;
      Canvas.DrawLine(p, ClipRect.BottomRight, Opacity);
      p.X := ClipRect.Right;
      p.Y := ClipRect.Bottom - long;
      Canvas.DrawLine(ClipRect.BottomRight, p, Opacity);
    end;
    begin
      d.X := ClipRect.Left;
      d.Y := ClipRect.Bottom;
      p.X := ClipRect.Left + long;
      p.Y := ClipRect.Bottom;
      Canvas.DrawLine(d ,p , Opacity);
      p.X := ClipRect.Left;
      p.Y := ClipRect.Bottom - long;
      Canvas.DrawLine(d ,p , Opacity);
    end;
    begin
      d.X := ClipRect.Right;
      d.Y := ClipRect.Top;
      p.X := ClipRect.Right - long;
      p.Y := ClipRect.Top;
      Canvas.DrawLine(d, p, Opacity);
      p.X := ClipRect.Right;
      p.Y := ClipRect.Top + long;
      Canvas.DrawLine(d, p, Opacity);
    end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Font := TFont.Create;
  Printer.ActivePrinter;
  Listbox1.Items.AddStrings(Printer.Fonts);
  ListBox1.Sorted := true;
  DisplayMetrics;
end;

procedure TForm3.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  edit2.Text := Item.Text;
  Font.Family := edit2.Text;
  PaintBox1.Repaint;
end;

procedure TForm3.ListBox1KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    edit2.Text := ListBox1.Items[ListBox1.ItemIndex];
    Font.Family := edit2.Text;
    PaintBox1.Repaint;
  end;
end;

procedure TForm3.PaintBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
var r: single;
begin
  if ssCtrl in Shift then
  begin
    r := PaintBox1.scale.x;
    if wheeldelta < 0 then
    begin
      Font.Size := Font.Size - 1;
      PaintBox1.Repaint;
    end
    else
    if wheeldelta > 0 then
    begin
      Font.Size := Font.Size + 1;
      PaintBox1.Repaint;
    end;
    edit1.Text := inttostr(round(Font.Size));
  end;
end;

procedure TForm3.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
var r: TRectF;
    s: string;
    t: single;
    m: TMetrics;
    la, le: TPointF ;
begin
  PaintBox1.Canvas.Font.Family := Font.Family;
  PaintBox1.Canvas.Font.Style := Font.Style;;
  PaintBox1.Canvas.Fill.Color := TAlphaColors.Black;
  PaintBox1.Canvas.Font.Size := Font.Size;
  t := PaintBox1.Width / 2;
  s := 'A';
  r := PaintBox1.ClipRect;
  r.Left := t - (Canvas.TextWidth(s) / 2);
  r.Right := r.Left + Canvas.TextWidth(s);
  t := PaintBox1.Height / 2;
  r.Bottom := t + (Canvas.TextHeight(s) / 2);
  r.Top := r.Bottom - Canvas.TextHeight(s);

  PaintBox1.Canvas.FillText(r , s, false, 1, [{TFillTextFlag.ftRightToLeft}], TTextAlign.Center, TTextAlign.Leading);

  DrawGuide(PaintBox1.Canvas, r);
  m := TMetrics.Create(Font);
  Canvas.Stroke.Color := TAlphaColors.Black;
  Canvas.Stroke.Kind := TBrushKind.Solid;
  t := m.Ascender + r.Top;
  PaintBox1.Canvas.DrawLine(TPointF.Create(r.Right - 5, t), TPointF.Create(r.Right, t), 0.5);
  t := m.Caps + r.Top;
  PaintBox1.Canvas.DrawLine(TPointF.Create(r.Right - 5, t), TPointF.Create(r.Right, t), 0.5);
  t := m.Base + r.Top;
  PaintBox1.Canvas.DrawLine(TPointF.Create(r.Right - 5, t), TPointF.Create(r.Right, t), 0.5);
  t := m.Descender + r.Top;
  PaintBox1.Canvas.DrawLine(TPointF.Create(r.Right - 5, t), TPointF.Create(r.Right, t), 0.5);
  m.Free;
end;

{ TMetrics }

constructor TMetrics.Create(const Font: TFont);
begin
  read(font);
end;

procedure TMetrics.Read(Font: TFont);
var r: TRectF;
    canvas: TCanvas;
    p: TPathData;
    i: integer;
begin
  canvas := Form3.PaintBox1.Canvas;
  p := TPathData.Create;
  canvas.Font.Family := Font.Family;
  canvas.Font.Size := font.Size;
  canvas.Font.Style := font.Style;
  Top := 0;
  Bottom := Canvas.TextHeight('A');
  r.Right := Canvas.TextWidth('A');
  r.Bottom := Bottom;
  r.Top := 0;
  r.Left := 0;
  canvas.TextToPath(p, r, 'I', false, TTextAlign.Leading, TTextAlign.Leading);
  Ascender := p[0].Point.y;
  Base := p[1].Point.y;
  for i := 1 to p.Count - 1 do
  begin
    if p[i].Point.y < Ascender then Ascender := p[i].Point.y;
    if p[i].Point.y > Base then Base := p[i].Point.y;
  end;
  p.Clear;
  canvas.TextToPath(p, r, 'y', false, TTextAlign.Leading, TTextAlign.Leading);
//  showmessage(p.Data);
  Caps := p[1].Point.y;
  Descender := p[0].Point.y;
  for i := 1 to p.Count - 1 do
  begin
    if p[i].Point.y < Caps then Caps := p[i].Point.y;
    if p[i].Point.y > Descender then Descender := p[i].Point.y;
  end;
  p.Free;
end;

end.
