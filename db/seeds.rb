User.create(
  username: "admin",
  salt: Time.now.to_s,
  crypted_password: User.hexdigest("must_change_password", Time.now.to_s),
  is_admin: true
)

Color.create(
  name: "default",
  title: "#333333",
  frame: "#aed9e6",
  text1: "#ffffff",
  text2: "#444444",
  bg1: "#444444",
  bg2: "#ffffff"
)

Shop.create(
  name: "店舗名",
  contents1: "住所：<br>電話番号：<br>営業時間<br>",
  contents2: ""
)

TextTemplate.create(
  name: "店舗出品テキスト",
  header: "ヘッダー",
  footer: "フッター",
  col1_title: "商品詳細",
  col1_text: "商品詳細の説明",
  col2_title: "発送詳細",
  col2_text: "発送詳細の説明",
  col3_title: "支払詳細",
  col3_text: "支払詳細の説明",
  col4_title: "注意事項",
  col4_text: "ノークレーム、ノーリターンでお願いします。",
  col5_title: "店舗詳細・古物取扱証明に関して",
  col5_text: "古物商許可証第xxxxxxxxxxxxxx号"
)

html_template = <<EOT
{{kanri_no_prefix}}
<center>
<table bgcolor="#ff6600" cellpadding="10" cellspacing="1" width="600">
<tr>
<th>
<font color=#ffffff size="3">{{{shop.name}}}</font>
</th>
</tr>
</table>
<br />
{{{text_template.header}}}
<table width="600" cellspacing="0" cellpadding="10" border="0">
<tbody>
<tr>
<td align="center" bgcolor={{{color.frame}}}>
<b><font size=4 color={{{color.title}}}>
{{{shohin_title}}}
</font></b>
</td>
</tr>
</tbody>
</table>
<table width="600" cellspacing="2" cellpadding="2" bgcolor={{{color.frame}}}>
<tbody>
<tr>
<td>
<table width="100%" cellspacing="3" cellpadding="10" border="0">
<tbody>
<tr>
<td align="center" bgcolor={{{color.bg1}}}>
<b><font size="3" color={{{color.text1}}}>
{{{text_template.col1_title}}}
</font></b>
</td>
</tr>
<tr>
<td width="100%" align="left" bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{shohin_detail}}}
<br />
{{{text_template.col1_text}}}
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="3" cellpadding="10" border="0">
<tbody>
<tr>
<td align="center" bgcolor={{{color.bg1}}}>
<b><font size="3" color={{{color.text1}}}>
{{{text_template.col2_title}}}
</font></b>
</td>
</tr>
<tr>
<td width="100%" align="left" bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{text_template.col2_text}}}
</font>
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="3" cellpadding="10" border="0">
<tbody>
<tr>
<td align="center" bgcolor={{{color.bg1}}}>
<b><font size="3" color={{{color.text1}}}>
{{{text_template.col3_title}}}
</font></b>
</td>
</tr>
<tr>
<td width="100%" align=left bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{text_template.col3_text}}}
</font>
</td>
</tr>
</tbody></table>
<table width="100%" cellspacing="3" cellpadding="10" border="0">
<tbody>
<tr>
<td align="center" bgcolor={{{color.bg1}}}>
<b><font size="3" color={{{color.text1}}}>
{{{text_template.col4_title}}}
</font></b>
</td>
</tr>
<tr>
<td width="100%" align=left bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{text_template.col4_text}}}
</font>
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="3" cellpadding="10" border="0">
<tbody>
<tr>
<td align="center" bgcolor={{{color.bg1}}}>
<b><font size="3" color={{{color.text1}}}>
{{{text_template.col5_title}}}
</font></b>
</td>
</tr>
<tr>
<td width="100%" align="left" bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{shop.contents1}}}
<br />
{{{text_template.col5_text}}}
</font>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table><br />
<br />
{{{text_template.footer}}}
</center> 
EOT

HtmlTemplate.create(
  name: "店舗HTMLテンプレート",
  contents: html_template
)

