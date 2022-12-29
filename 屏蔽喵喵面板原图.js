import plugin from '../../lib/plugins/plugin.js'
import { segment } from 'oicq'
// 两个都填则一起回复只填一项则纯文本或图片

// 文本回复
const Textreply = '嗯꒰⑅°͈꒳​°͈꒱？原图？是什么东西哦~';
//图片回复(填写图片链接或路径)
const imgreply = 'https://gchat.qpic.cn/gchatpic_new/746659424/4144974507-2439053290-125E4E51B9D45F2C955E6675AF7C6CEE/0?term=3&is_origin=0';
export class example extends plugin {
  constructor() {
    super({
      name: '屏蔽',
      dsc: '屏蔽原图',
      event: 'message.group',
      priority: 1,
      rule: [
        {
          reg: '^#?(获取|给我|我要|求|发|发下|发个|发一下)?原图(吧|呗)?$',
          fnc: 'shield'
        }
      ]

    })
  }


  async shield(e) {
    if (!e.source) return false;
    if (e.isMaster) return false;//主人可以获取
    let source = (await e.group.getChatHistory(e.source.seq, 1)).pop();
    let key = `miao:original-picture:${source.message_id}`
    let res = await redis.get(key)
    if (!res || /character-img/.test(res)) return false;
    let msg = [
      Textreply ? Textreply : "",
      imgreply ? segment.image(imgreply) : "",
    ]
    e.reply(msg)
    return true;
  }

}

