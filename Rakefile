require "sinatra"
require "sinatra/activerecord"
require "sinatra/activerecord/rake"
require File.join(File.dirname(__FILE__), "app/main")
require File.join(File.dirname(__FILE__), "app/database")

task :add_data => [
  "add_slave",
  "add_admin",
  "add_color",
  "add_shop",
  "add_text_template",
  "add_html_template"
]

task :add_slave do
  @slave = User.new
  @slave.username = "user1"
  @slave.salt = Time.now.to_s
  @slave.crypted_password = @slave.hexdigest("user1", @slave.salt)
  @slave.is_admin = false
  @slave.save
end

task :add_admin do
  @admin = User.new
  @admin.username = "master"
  @admin.salt = Time.now.to_s
  @admin.crypted_password = @admin.hexdigest("2381", @admin.salt)
  @admin.is_admin = true
  @admin.save
end

task :add_color do
  @color = Color.new
  @color.name = "default"
  @color.title = "333333"
  @color.frame = "aed9e6"
  @color.text1 = "ffffff"
  @color.text2 = "444444"
  @color.bg1 = "444444"
  @color.bg2 = "ffffff"
  @color.save
end

task :add_shop do
  @shop = Shop.new
  @shop.name = "Shop 1"
  @shop.contents1 = "Awesome shop no 1"
  @shop.contents2 = "Tel: 000-0000-0000"
  @shop.save
end

task :add_text_template do
  @tmpl = TextTemplate.new
  @tmpl.name = "shop 1 text template"
  @tmpl.header = "Awesome shop no 1 header"
  @tmpl.footer = "Awesome shop no 1 footer"
  @tmpl.col1_title = "商品詳細"
  @tmpl.col1_text = ""
  @tmpl.col2_title = "発送詳細"
  @tmpl.col2_text = "すぐ送ります。"
  @tmpl.col3_title = "支払詳細"
  @tmpl.col3_text = "現金のみです。"
  @tmpl.col4_title = "注意事項"
  @tmpl.col4_text = "ノークレームノーリターンでお願いします。"
  @tmpl.col5_title = "店舗詳細"
  @tmpl.col5_text = "名古屋市にあります。"
  @tmpl.save
end

task :add_html_template do
  @tmpl = HtmlTemplate.new
  @tmpl.name = "shop 1 html template"
  @tmpl.contents = <<EOT
 <center>
<table bgcolor="#ff6600" cellpadding="10" cellspacing="1" width="600">
<tr>
<th>
<font color=#ffffff size="3">{{{shop.name}}} <!-- 店舗名 --></font>
</th>
</tr>
</table>
<br />
{{{text_template.header}}} <!-- ヘッダー -->
<table width="600" cellspacing="0" cellpadding="10" border="0">
<tbody>
<tr>
<td align="center" bgcolor={{{color.frame}}}>
<b><font size=4 color={{{color.title}}}>
{{{shohin_title}}} <!-- 商品名 -->
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
{{{text_template.col1_title}}} <!-- タイトル1（商品詳細） -->
</font></b>
</td>
</tr>
<tr>
<td width="100%" align="left" bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{shohin_detail}}} <!-- 商品詳細 -->
<br />
{{{text_template.col1_text}}} <!-- 商品詳細フッター -->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="3" cellpadding="10" border="0">
<tbody>
<tr>
<td align="center" bgcolor={{{color.bg1}}}>
<b><font size="3" color={{{color.text1}}}>
{{{text_template.col2_title}}} <!-- タイトル2（発送詳細） -->
</font></b>
</td>
</tr>
<tr>
<td width="100%" align="left" bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{text_template.col2_text}}} <!-- テキスト2（発送詳細） -->
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
{{{text_template.col3_title}}} <!-- タイトル3（支払詳細） -->
</font></b>
</td>
</tr>
<tr>
<td width="100%" align=left bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{text_template.col3_text}}} <!-- テキスト3（支払詳細） -->
</font>
</td>
</tr>
</tbody></table>
<table width="100%" cellspacing="3" cellpadding="10" border="0">
<tbody>
<tr>
<td align="center" bgcolor={{{color.bg1}}}>
<b><font size="3" color={{{color.text1}}}>
{{{text_template.col4_title}}} <!-- タイトル4（注意事項） -->
</font></b>
</td>
</tr>
<tr>
<td width="100%" align=left bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{text_template.col4_text}}} <!-- テキスト4（注意事項） -->
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
{{{text_template.col5_title}}} <!-- タイトル5（店舗詳細・古物取扱証明に関して） -->
</font></b>
</td>
</tr>
<tr>
<td width="100%" align="left" bgcolor={{{color.bg2}}}>
<font size="2" color={{{color.text2}}}>
{{{shop.contents1}}} <!-- 店舗1（店舗情報） -->
<br />
{{{text_template.col5_text}}} <!-- テキスト5（店舗詳細・古物取扱証明に関して） -->
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
<small>Yahoo!かんたん決済がご利用いただけます</small><br />
<a target=new href="http://payment.yahoo.co.jp/"><img width=468 height=60 border=0 src="http://image.auctions.yahoo.co.jp/phtml/auc/jp/images/kantan2.gif"></a><br />
<br />
<small>ほかにも出品しています。よろしければご覧ください。</small><br />
<a href="http://auctions.yahoo.co.jp/jp/booth/{{{shop.contents9}}}"><img width="468" height="60" border="0" src="http://image.auctions.yahoo.co.jp/banner.gif"></a>
{{{text_template.footer}}}
</center> 
EOT
  @tmpl.save
end
