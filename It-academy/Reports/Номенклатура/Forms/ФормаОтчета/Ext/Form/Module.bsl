﻿
&НаСервере
Процедура СформироватьНаСервере()
  	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");  // Получим заготовку отчета 
	ТабДокумент = ОтчетОбъект.Сформировать();  // ЗначениеВРеквизитеФормы(ОтчетОбъект, "Отчет");
                                    

КонецПроцедуры    

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

