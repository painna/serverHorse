object Dm1: TDm1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 167
  Width = 271
  object Conexao: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 32
    Top = 32
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 160
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 160
    Top = 96
  end
end
