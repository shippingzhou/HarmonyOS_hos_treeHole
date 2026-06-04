import { router } from '@kit.ArkUI'

@Entry
@Component
struct PrivacyPage {

  build() {
    Column() {
      Navigation() {
        Scroll() {
          Column() {
            Text('字幕灯牌LED - 隐私政策')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 12 })

            Text('最后更新日期：2026 年 5 月 27 日')
              .fontSize(14)
              .fontColor('#999999')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 20 })

            Text('感谢您使用「LED 弹幕灯牌」（以下简称"本应用"）。我们非常重视您的隐私。本隐私政策旨在向您说明本应用如何收集、使用和保护您的信息。')
              .fontSize(15)
              .fontColor('#333333')
              .lineHeight(24)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 20 })

            Text('1. 信息收集')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            Text('本应用不收集任何个人信息。具体说明如下：\n\n无需注册登录：您无需提供任何个人账户信息即可使用本应用的全部功能。\n不收集设备信息：本应用不会收集您的设备型号、操作系统版本、唯一设备标识符（如 IMEI、OAID）等信息。\n不收集位置信息：本应用不会获取或使用您的地理位置。\n不收集使用数据：本应用不会跟踪您的使用行为、操作记录或使用习惯。')
              .fontSize(15)
              .fontColor('#333333')
              .lineHeight(24)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 20 })

            Text('2. 权限说明')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            Text('本应用不申请任何敏感权限。正常运行所需的权限仅限于本地数据存储，用于保存您的灯牌文字记录和应用设置偏好（如字体大小、颜色、滚动速度等）。所有数据仅存储在您的设备本地，不会上传至任何服务器。')
              .fontSize(15)
              .fontColor('#333333')
              .lineHeight(24)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 20 })

            Text('3. 第三方服务')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            Text('本应用不集成任何第三方分析工具、广告SDK或社交分享SDK，不会向任何第三方传输您的数据。')
              .fontSize(15)
              .fontColor('#333333')
              .lineHeight(24)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 20 })

            Text('4. 数据安全')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            Text('由于本应用不收集任何个人信息，因此不存在个人信息泄露的风险。本地存储的数据仅您本人可访问。')
              .fontSize(15)
              .fontColor('#333333')
              .lineHeight(24)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 20 })

            Text('5. 儿童隐私')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            Text('本应用不收集任何年龄用户的信息，包括 14 周岁以下的儿童。')
              .fontSize(15)
              .fontColor('#333333')
              .lineHeight(24)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 20 })

            Text('6. 隐私政策更新')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            Text('如本隐私政策发生变更，我们会在本页面更新"最后更新日期"。变更后的隐私政策自发布之日起生效。')
              .fontSize(15)
              .fontColor('#333333')
              .lineHeight(24)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 20 })

            Text('7. 联系我们')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            Text('如您对本隐私政策有任何疑问，请联系我们。\n\n邮箱：121819555@qq.com')
              .fontSize(15)
              .fontColor('#333333')
              .lineHeight(24)
              .width('100%')
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .padding(20)
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .backgroundColor('#FFFFFF')
      }
      .title("隐私政策")
      .mode(NavigationMode.Stack)
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(false)
      .backgroundColor('0xf4f4f7')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F4F4F7')
  }
}
