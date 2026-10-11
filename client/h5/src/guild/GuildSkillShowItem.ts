import { BaseItem1 } from '../common/BaseItem1';
import { ResManager } from '../common/ResManager';
import { GuildModel } from '../commonModel/GuildModel';
import { Trim, Util } from '../util/Util';

export class GuildSkillShowItem extends BaseItem1 {
    cfg;
    data;
    model: GuildModel;

    public constructor(parent?) {
        super(parent);

        this.model = GuildModel.GetInstance();
        this.base_file = 'guild';
        this.layout_file = 'GuildSkillShowItem';
    }

    public SetData(data?) {
        if (!data) {
            return;
        }
        this.data = data;
        this._lb_level.text = data.learn_lv;
        this.UpdateItem(data.skill_id);
    }

    public UpdateItem(skill_id?) {
        let guildSkillCfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_guild_skill', false);
        // [ts2lua]Guildskill下标访问可能不正确
        this.cfg = guildSkillCfg[skill_id];
        this._lb_name.text = this.cfg.skill_name;
        let guild_info = this.model.GetGuildInfo();
        let unlock = guild_info && guild_info.guild_lv >= this.cfg.unlock_lv;
        let unlock2 = this.data || unlock;
        this._img_lock.visible = !unlock2;
        this._group_lv.visible = unlock;

        ResManager.GetInstance().SetImageSprite(this, this._img_icon, 'guild_asset', Trim(this.cfg.icon), false);
        Util.SetImageGray(this._img_icon, !unlock);
    }

    public SetInfoVisible(boo: boolean) {
        this._lb_name.visible = this._Image3.visible = this._group_lv.visible = boo;
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    _Image1: Laya.Image;
    _img_icon: Laya.Image;
    _img_lock: Laya.Image;
    _img_select: Laya.Image;
    _group_lv: Laya.Box;
    _Image2: Laya.Image;
    _lb_level: Laya.Label;
    _Image3: Laya.Image;
    _lb_name: Laya.Label;
    _reddot: Laya.Image;
    public GetComponents() {
        [this._Image1, this._img_icon, this._img_lock, this._img_select, this._group_lv, this._Image2, this._lb_level, this._Image3, this._lb_name, this._reddot] = this.GetChildrenByNames(['_Image1', '_img_icon', '_img_lock', '_img_select', '_group_lv', '_Image2', '_lb_level', '_Image3', '_lb_name', '_reddot']);
    }
}
window['GuildSkillShowItem'] = GuildSkillShowItem;
