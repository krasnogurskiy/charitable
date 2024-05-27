<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta charset="utf-8">
    <title>Charitable</title>
</head>
<body onload="document.payForm.submit()">

<form method="POST" name="payForm" action="https://www.liqpay.ua/api/3/checkout"
      accept-charset="utf-8">
    <input type="hidden" name="data" value="${data}"/>
    <input type="hidden" name="signature" value="${signature}"/>
    <#--<input type="hidden" name = "_csrf" value="${_csrf.token}"/>-->
</form>

</body>
</html>