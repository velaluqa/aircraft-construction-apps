# NOTE: THIS IS JUST AN EXAMPLE HELP FILE FOR DEVELOPMENT

**Direct Operating Cost**
===================================
Diese Web-App erlaubt es die Massen- und Leistungsdaten von zwei Flugzeugen über die Reichweite miteinander zu vergleichen. Sie können für die Analyse der direkten Betriebskosten einzelnen Kostenparamter vorgeben. Ebenso ist es möglich ein eigenes Flugzeug über Massendaten zu generieren, welches mit einem bestehenden Flugzeug verglichen werden soll.

[TOC]


**Kostenmethode**
----------------------
Basierend auf dem Nutzlast-Reichweiten Diagramm (NRD) können die Kosten über die Reichweite bestimmt werden. Ein typisches NRD ist in folgender Abbildung dargestellt.

![enter image description here][1]

- Punkt A: operationelle Reichweite = 0
    - $R = 0$, $m_{PL} = m_{PL,max}$, $m_{TO} = m_{PL,max} + m_{OE}$
- Punkt B: Reichweite mit maximaler Nutzlast
    -   $m_{PL} = m_{PL,max}$, $m_{TO} = m_{TO,max}$
- Punkt C: Nutzlast bei maximaler Kraftstoffmasse
    - $m_{TO} = m_{TO,max}$ , $m_{F} = m_{F,max}$,
- Punkt D: Überführungsreichweite
    - $m_{F} = m_{F,max}$, $m_{PL} = 0$

----------

### Nutzlast-Reichweiten-Diagramm
Um das NRD zu bestimmen, müssen die Reichweiten und Nutzlast Paare bestimmt werden. Dafür wird ausgehend von den gegebenen Parametern (siehe Tabelle) und den Reserveparemtern (Zeit für den Warteflug ($t_{hold}$), Reichweite für den Ausweichflug ($R_{Div}$) und der Contigency Anteil ($f_{RF_{c}}$)) die operationelle Reichweite für die entsprechende Nutzlast bestimmt.


Die Abflugmasse eines Flugzeuges setzt sich wie folgt zusammen:

$$m_{TO} = m_{PL} + m_{OE} + m_{F,res} $$

Mit den Reserveanteilen eribgt sich:
$$m_{F,res} = m_{F,div} + m_{F,hold} + m_{TF}\cdot f_{RF_{c}}$$
$$m_{TO} = m_{PL} + m_{OE} + m_{F,div} + m_{F,hold} +  m_{TF}\cdot f_{RF_{c}}$$

Umstellen nach Reisekraftstoff:
$$ m_{TF} = \frac{m_{TO} - m_{PL} - m_{OE} - m_{F,div} - m_{F,hold} }{ 1+ f_{RF_{c}}}     (1)$$

Die Kraftstoffmassen für den Ausweich- und den Warteflug sind unbekannt. Sie können aber über die Breguet'schen Reichweitenformel bestimmt werden, da die reichweiten für beide Reserveranteile bekannt sind.
$$ R = \eta\cdot ln\left(\frac{m_{Anfang}}{m_{Ende}}\right)$$
$$ \eta = \frac{v}{SFC\cdot \epsilon \cdot g_0 }$$
Für die Anfangs- und Ensmasse ergeben sich:
$$m_{Anfang} = m_{PL} + m_{OE} + m_{F,div} + m_{F,hold} $$
$$m_{Ende} = m_{PL} + m_{OE} $$
Durch Umstellen der Reichweitenformel und Einsetzen der Massen ergebit sich für die gesuchten Krafststoffmassen folgendes:
$$m_{F,div} + m_{F,hold} = \left(m_{PL} + m_{OE}\right) \cdot \left(e^{\frac{R_{Div} + R_{hold}}{\eta}}-1\right) $$
Wird diese Gleichung in Gleichung (1) eingesetzt, kann für die gegebenen Daten der Reisekraftstoff und somit die Reisereichweite für die 4 markanten Punkte des Diagramms bestimmt werden.
$$ m_{TF} = \frac{m_{TO} - \left(m_{PL} + m_{OE}\right)\cdot \left(e^{\frac{R_{Div} + R_{hold}}{\eta}}\right)}{ 1+ f_{RF_{c}}} $$
$$ R_{Reise} = \eta\cdot ln\left(\frac{m_{PL} + m_{OE} + m_{TF}}{m_{PL} + m_{OE}}\right)$$

### Flugstunden und Anzahl der Flüge
Die Anzahl der Flüge pro Jahr für eine gegebene Reichweite und Geschwindigkeit bestimmen sich folgender Maßen:
$$f = \frac{6011[h]}{\frac{R[km]}{v[km/h]} + 1,83[h]}$$
Die 6011 Stunden ergeben sich aus einer theoretischen Überlegung. Wird angenommen, dass das ganze Jahr über 24 Stunden pro Tag geflogen werden kann, entspreche dies 8760 möglichen Flugstunden. Da aber nach gewissen Zeiträumen Standzeiten in Form von C/D-Checks oder Reperaturen anfallen und Nachtflugverbot von 23:00 - 6:00 besteht verkleinert sich die Zeit um 2749 Stunden auf 6011 Stunden. Die 1,83 Stunden ergeben sich aus einem Zuschlag für die Blockzeit.
Der Quotient $\frac{R}{v}$ entspricht dabei den Flugstunden $fh$ für einen Flug. Multipliziert mit den Anzahl der Flüge ergeben sich die Flugstunden pro Jahr $fh_{pa}$.

### Transportarbeit
Aus dem NRD kann nun die Transpportarbeit bestimmt werden. Diese ist definiert als:
$$TKO = m_{PL} \cdot R$$
Die Transportarbeit kann auch für ein Jahr bestimmt werden.
$$TKO_{pa} = TKO \cdot f$$

### Direkte Betriebskosten (DOC)
Die direkten Betriebskosten (DOC)für einen Flug berechnen sich wie folgt:

$$ C_{spec,own,pf} = \frac{p_{OEM} \cdot m_{OE} \cdot a}{f}$$
$$ C_{spec,fuel,pf} = p_{fuel} \cdot m_{TF} $$
$$ C_{spec,MTOM,pf} = p_{MTOM} \cdot m_{MTOM} \cdot fh$$
$$ C_{spec,PL,pf} = p_{PL} \cdot m_{PL} $$
$$ C_{spec,total,pf} = C_{spec,own,pf} + C_{spec,fuel,pf} + C_{spec,MTOM,pf} + C_{spec,PL,pf} $$
$$ a = \frac{i\cdot\left(1-r\cdot\left(\frac{1}{1+i}\right)^{ap}\right)}{\left(1-\left(\frac{1}{1+i}\right)^{ap}\right)}$$



Die einzelnen Einflussparameter sind hier zusammengefasst:

Symbol | Einheit | Bezeichung | Bespiel
:----------|:-------:|:------
$p_{OEM}$ | €/kg | Preis pro Betriebsleermasse (operational empty weight) | 1700 €/kg
$p_{fuel}$ | €/kg | Preis pro Reisekraftstoffmasse (tripfuel mass) | 0,2 €/kg
$p_{MTOM}$ | €/kg | Preis pro Abflugmasse (Take-Off mass) | 0,01 €/kg/fh
$p_{PL}$ | €/kg | Preis pro Nutzlast (Payload) | 0,28 €/kg
$m_{OE}$ | kg | Betriebsleermasse (operational empty weight)
$m_{TF}$ | kg | Reisekraftstoffmasse (tripfuel mass)
$m_{MTOM}$ | kg | Abflugmasse (Take-Off mass)
$m_{PL}$ | kg |  Nutzlast (Payload)
$ap$ | - | Abschreibungszeitraum (amortization period) | 12 Jahre
$r$ | % | Restwert (residual value factor) | 10 %
$i$ | - | Abschreibungszeitraum (amortization period) | 5 %
$a$ | - | Annuitätenfaktor (annuity factor)

Die direkten Betriebskosten pro Jahr ergeben sich durch Multiplikation mit der Fluganzahl $f$.

### Stückkosten (SMK)
Die Stückkosten ergeben sich durch division der direkten Kosten durch die Transportarbeit.

### Sitzladefaktor
Der Sitzladefaktor ist abhängig von der mitgenommenen Nutzlast und wird folgendermaßen bestimmt:
$$ n_{PL} =\frac{m_{PL}}{m_{OE}+m_{PL}+m_{F}}$$

### Break even
Der Break Even ist der Punkt an dem sich die Kosten und der Gewinn ausgleichen. Wird die Nutzlast erhöht, erhöht sich der Gewinn.
$$BE = \frac{C_{spec,total}\cdot m_{PL}}{r_{Trans}}$$
$r_{Trans}$ ist dabei die Einahme pro Tonnen-Kilometer.

**Parametereingabe**
---------
Ausgehend für die Berechnung des NRD für ein Flugzeug (auch für ein eigenes/neues) sind folgende Daten:
Symbol | Einheit | Bezeichung
:------|:------:|:-------
$m_{TO,max}$ | kg | maximale Abflugmasse (maximium Take-Off mass)
$m_{F,max} $| kg | maximale Kraftstoffmasse (maximium fuel mass)
$m_{OE} $| kg | Betriebsleermasse (operating empty mass)
$m_{PL,max}$ | kg | maximale Nutzlast (maximium payload)
$L/D$ = $\frac{1}{\epsilon}$ | - | reziproke Gleitzahl (L/D ratio)
$SFC$ | kg/daN | schubspezifischer Kraftstoffverbrauch (thrust specific fuel consumption)
$v$ | km/h | Reiseflug-Geschwindigkeit (cruise speed, Long-Range-Cruise)

Um die DOC bzw. die SMK zu bestimmen, müssen folgende Daten angegeben werden:
Symbol | Einheit | Bezeichung
:------|:------:|:-------
$p_{OEM}$ | €/kg | Preis pro Betriebsleermasse (operational empty weight)
$p_{fuel}$ | €/kg | Preis pro Reisekraftstoffmasse (tripfuel mass)
$p_{TO,max}$ | €/kg | Preis pro Abflugmasse (Take-Off mass)
$p_{PL}$ | €/kg | Preis pro Nutzlast (Payload)
$m_{TO,max}$ | kg | Abflugmasse (Take-Off mass)
$m_{PL}$ | kg |  Nutzlast (Payload) abhängig von der Reichweite
$ap$ | - | Abschreibungszeitraum (amortization period)
$r$ | % | Restwert (residual value factor)
$i$ | - | Abschreibungszeitraum (amortization period)
$r_{Trans}$ |€/t/km| Transportrate (transport rate)



**Massen- und Leistungsparameter**
-------------------
Die auzuwählenden Parameter sind hier aufgelistet:

### Massen
Symbol | Einheit | Bezeichung
:----------|:-------:|:------
$m_P$ | kg | Nutzlast (Payload)
$m_F$ | kg | Kraftstoffmasse (fuel mass)
$m_{F,res}$ | kg | Masse des Reservekraftstoffes (reserve fuel mass)
$m_{TO}$ | kg | Abflugmasse (Take-Off mass)
$m_m$ | kg | mittlere Masse (mean gross weight)

### Kosten pro Flug und pro Jahr
Symbol | | Einheit | Bezeichung
:----------||:-------:|:------
$C_{own,pf}$| $C_{own,pa}$ | € |Anschaffungskosten (ownership cost)
$C_{fuel,pf}$|$C_{fuel,pa}$ | € |Kraftstopffksoten (fuel cost)
$C_{MTOM,pf}$ |$C_{MTOM,pa}$ | € | (maximum Take-Off mass cost)
$C_{PL,pf}$|$C_{PL,pa}$  | € | Abfertigungsgebühren (payload cost)
$C_{total,pf}$|$C_{total,pa}$ | € |Gesamtkosten (total cost)

### Stückkosten pro Flug und pro Jahr
Symbol | | Einheit | Bezeichung
:----------||:-------:|:------
$C_{spec,own,pf}$| $C_{spec,own,pa}$ | € |Anschaffungskosten (ownership cost)
$C_{spec,fuel,pf}$|$C_{spec,fuel,pa}$ | € |Kraftstopffksoten (fuel cost)
$C_{spec,MTOM,pf}$ |$C_{spec,MTOM,pa}$ | € | (maximum Take-Off mass cost)
$C_{spec,PL,pf}$|$C_{spec,PL,pa}$  | € | Abfertigungsgebühren (payload cost)
$C_{spec,total,pf}$|$C_{spec,total,pa}$ | € |Gesamtkosten (total cost)

### weitere Parameter

Symbol | Einheit | Bezeichung
:------|:------:|:-------
$TKO_{pf} $| kg$\cdot$km | Transportarbeit pro Flug (producticity per flight)
$TKO_{pa} $| kg$\cdot$km | Transportarbeit pro Jahr (producticity per year)
$BE $| kg |  (break even)
$n_{PL}$ |-| Nutzlastfaktor (payload factor)
$f$ | - | Flüge pro Jahr (flights per year)
$fh$ | - | Flugstunden (flighthours)
$fh_{pa}$|- | Flugstunden pro Jahr (flighthours per year)










> Written with [StackEdit](https://stackedit.io/).


  [1]: http://comet.ilr.tu-berlin.de/appdocs/pics/NRD.jpg
