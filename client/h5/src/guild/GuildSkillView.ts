import { BaseItem1 } from '../common/BaseItem1';
import { EventName } from '../common/EventName';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { WordManager } from '../common/WordManager';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { RoleManager } from '../commonModel/RoleManager';
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from '../util/ColorUtil';
import { ErlangParser } from '../util/ErlangParser';
import { GameResPath } from '../util/GameResPath';
import { Util, GetLocalPositionY, SetLocalPositionY, LoadLuaConfigAB, HtmlColorTxt, RefBoxVLayout, RefBoxChildsLayout } from '../util/Util';
import { GuildSkillShowItem } from './GuildSkillShowItem';
import { GuildSkillZItem } from './GuildSkillZItem';
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";

export class GuildSkillView extends BaseItem1 {
    item_list: { [key: number]: GuildSkillZItem };
    show_item: GuildSkillShowItem;
    info_count: number = 0;
    is_layout: boolean;
    cfg_list;
    cfg_list2: ProtoRecvVObj<40040>['skill_list'];
    cur_skill_data: any;
    model: GuildModel;
    resMgr: ResManager;
    _fight_show: FightingShowSmallItem;
    public constructor(parent?) {
        super(parent);

        this.item_list = {};
        this.base_file = 'guild';
        this.layout_file = 'GuildSkillView';
        this.cur_skill_data = null;
        this.preload_server_config = {
            config_guild_skill: false,
            config_guild_skill_research: false
        };
        this.model = GuildModel.GetInstance();
        this.resMgr = ResManager.GetInstance();
        this.load_callback = () => {
            this.info_count = 0;
            this.is_layout = false;
            //this._scroller.vScrollBarSkin = ""
            this.FireEvent();
            this.InitView();
            this.InitEvent();
        };
    }

    public DeleteMe() {
        for (let key in this.item_list) {
            // [ts2lua]this.item_list下标访问可能不正确
            this.item_list[key].DeleteMe();
        }
        this.item_list = {};
        if (this.show_item) {
            this.show_item.DeleteMe();
            this.show_item = null;
        }
        if (this._fight_show) {
            this._fight_show.DeleteMe();
            this._fight_show = null;
        }
        super.DeleteMe();
    }

    InitView() {
        if (!this._fight_show) {
            this._fight_show = new FightingShowSmallItem(this._fight_con)
            this._fight_show.Load()
            this._fight_show.ExcuteCallback(() => {
            })
        }
        this.resMgr.SetOutsideImageSprite(this, this._icon_bg, GameResPath.GetIcon('guild', 'ui_Guild_08'));
        this.resMgr.SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath('38040009'));
        this.InitSkillItems();
    }

    FireEvent() {
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40040, 'c', 1);
    }

    InitEvent() {
        Util.AddClickEvent(
            this._btn_up_box,
            () => {
                let y = GetLocalPositionY(this.Content) - 190;
                if (y <= 0) {
                    return;
                }
                SetLocalPositionY(this.Content, 0);
            },
            this,
            true
        );

        Util.AddClickEvent(
            this._btn_down_box,
            () => {
                let y = GetLocalPositionY(this.Content);
                if (y >= 190) {
                    return;
                }
                SetLocalPositionY(this.Content, 193);
            },
            this,
            true
        );

        Util.AddClickEvent(
            this._btn_levelup,
            () => {
                if (!this.cur_skill_data) {
                    return;
                }
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40042, 'i', this.cur_skill_data.skill_id);
            },
            this,
            true
        );
        this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, () => {
            this.UpdateView();
        });
        this.BindVar(this.model, 'skill_info', () => {
            this.UpdateView();
        });
        this.BindEvent(this.model, GuildEvent.SELECT_SKILL_ITEM, (data?, cfg?) => {
            let tdata = data || cfg;
            this.cur_skill_data = tdata;
            this.UpdateShowData(tdata);
        });
        this.BindEvent(this.model, GuildEvent.UPDATE_SKILL_RED_STATUS, () => {
            this.UpdateView();
        });
    }

    UpdateView() {
        let info = this.model.GetSkillInfo();
        if (!info) {
            return;
        }

        this.cfg_list2 = info.skill_list;
        this.UpdateSkillItems();
        if (!this.cur_skill_data) {
            return;
        }
        for (let data of info.skill_list) {
            if (data.skill_id == this.cur_skill_data.skill_id) {
                this.cur_skill_data = data;
                this.UpdateShowData(data);
            }
        }
    }

    InitSkillItems() {
        let dic = this.resMgr.GetGameConfigFromCache(this, 'config_guild_skill', false);
        this.cfg_list = [];
        for (let key in dic) {
            // [ts2lua]dic下标访问可能不正确
            table.insert(this.cfg_list, dic[key]);
        }
        table.sort(this.cfg_list, (a?, b?) => {
            return a.unlock_lv < b.unlock_lv;
        });

        let cur_skill_data2 = null;

        for (let i = 0; i < this.cfg_list.length; i++) {
            var info = this.cfg_list[i];
            // [ts2lua]this.item_list下标访问可能不正确
            let item = this.item_list[info.skill_id];
            if (!item) {
                item = new GuildSkillZItem(this.Content);
                item.Load();
                this.item_list[info.skill_id] = item;
            }
            info.learn_lv = 0;
            item.ExcuteCallback(() => {
                item.SetDefault(this.cfg_list[i]);
                item.UpdateItem(this.cfg_list[i].skill_id);
            });
            cur_skill_data2 = cur_skill_data2 || info;
        }

        if (cur_skill_data2) {
            // [ts2lua]this.item_list下标访问可能不正确
            let item = this.item_list[cur_skill_data2.skill_id];
            item.ExcuteCallback(() => {
                item.Select(true);
            });
            this.cur_skill_data = cur_skill_data2;
            this.UpdateShowData(cur_skill_data2);
        }
    }

    UpdateSkillItems() {
        let list = this.cfg_list2;
        this.info_count = 0;
        for (let info of list) {
            // [ts2lua]this.item_list下标访问可能不正确
            let item = this.item_list[info.skill_id];
            if (item) {
                item.ExcuteCallback(() => {
                    item.SetData(info);
                    if (!this.is_layout) {
                        this.info_count += 1;
                        if (this.info_count >= list.length) {
                            this.is_layout = true;
                            this.LayoutContent(this.Content);
                        }
                    }
                });
            }
        }
    }

    UpdateShowData(data?) {
        LoadLuaConfigAB('Guildskillresearch', () => {
            this.UpdateShowSkillItem(data);
            let guild_info = this.model.GetGuildInfo();
            let Guildskill = this.resMgr.GetGameConfigFromCache(this, 'config_guild_skill', false);
            // [ts2lua]Guildskill下标访问可能不正确
            let cfg = Guildskill[data.skill_id];
            let unlock = guild_info && guild_info.guild_lv >= cfg.unlock_lv;
            this._btn_levelup.visible = unlock;
            this._lb_lock_tip.visible = !unlock;
            // [ts2lua]lua中0和空字符串也是true，此处unlock需要确认
            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this._lb_lock_tip.text = unlock && "" || "Guild Lv." + cfg.unlock_lv + " to unlock this skill"
            // } else if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
            // 	this._lb_lock_tip.text = unlock && "" || "กิลด์Lv." + cfg.unlock_lv + "ปลดล็อกสกิลนี้"
            // }else{
            this._lb_lock_tip.text = (unlock && '') || '结社' + cfg.unlock_lv + '级解锁此技能';
            // }
            let guild_skill_research_cfg = this.resMgr.GetGameConfigFromCache(this, 'config_guild_skill_research', false);
            // [ts2lua]guild_skill_research_cfg下标访问可能不正确
            let cur_cfg = guild_skill_research_cfg[data.skill_id + '@' + data.learn_lv];
            if (cur_cfg) {
                let cur_attr_list = JSON.parse(cur_cfg.attr_list);
                let cur_attr = cur_attr_list[0];
                let value = WordManager.ConvertToPercentValue(cur_attr[0], cur_attr[1]);
                this._Label1.text = `当 前：${WordManager.GetProperties(cur_attr[0])}+${value}`;
                this._lb_cur_attr.text = ``; //local_WordManager.GetProperties(cur_attr[0])+ (" + ") + value
            }
            // [ts2lua]guild_skill_research_cfg下标访问可能不正确
            let next_cfg = guild_skill_research_cfg[data.skill_id + '@' + (data.learn_lv + 1)];

            if (next_cfg) {
                let next_attr_list = JSON.parse(next_cfg.attr_list);
                let next_attr = next_attr_list[0];
                let value = WordManager.ConvertToPercentValue(next_attr[0], next_attr[1]);
                this._Label2.text = `下 级：`;
                this._lb_next_attr.text = `${WordManager.GetProperties(next_attr[0])}+${value}`; //local_WordManager.GetProperties(next_attr[0]) + (" + ") + value
                let cost_count = JSON.parse(next_cfg.learn_cost)[0][1];
                let own = this.model.GetDonate();
                // [ts2lua]lua中0和空字符串也是true，此处own >= cost_count需要确认
                let color = (own >= Number(cost_count) && Enum_ColorUtil_Dark.GREEN) || Enum_ColorUtil_Dark.RED;
                let str = HtmlColorTxt(own, color) + '/' + cost_count;

                this._tx_desc2.color = ColorUtil.GetReplaceChar(color);
                this._tx_desc2.text = own + '';
                this._tx_desc3.visible = true;
                this._tx_desc3.text = `/${cost_count}`;

                this._lb_max_tip.visible = false;
                this._group_attr_next.visible = true;
                this._Group1.visible = true;
            } else {
                this._tx_desc2.color = '#663915';
                this._tx_desc2.text = '-/-';
                this._tx_desc3.visible = false;
                this._btn_levelup.visible = false;
                this._lb_max_tip.visible = unlock;
                this._Group1.visible = false;
                this._group_attr_next.visible = false;
            }
            // this._Group1.refresh()
            RefBoxChildsLayout(this._Group1, 1);
            this._lb_skill_name.text = `Lv.${data.learn_lv} ${cfg.skill_name}`;
            this._fight_show.Updatefighting(data.cur_power);
            if (data.next_power == 0) {
                this._fight_show.UpdatefightingUp(0);
                this._fight_show.IsCenter(true, false);
            } else {
                this._fight_show.UpdatefightingUp(data.next_power - data.cur_power);
                this._fight_show.SetPowerOffset(this._fight_show.display_obj.width / 4);
            }
        });
    }

    UpdateShowSkillItem(data?) {
        if (!this.show_item) {
            this.show_item = new GuildSkillShowItem(this._group_item);
            this.show_item.Load();
        }
        this.show_item.ExcuteCallback(() => {
            this.show_item.SetData(data);
            this.show_item.SetInfoVisible(false);
        });
    }

    //box布局类
    LayoutContent(box: Laya.Box) {
        let repeat_x = 4; //列数
        let repeat_y = Math.ceil(box.numChildren / repeat_x); //行数
        let cell_w = 145; //格子大小
        let cell_h = 160;
        let gap_x = 5; //格子之间的间隔
        let gap_y = 5;

        //记录相对位置
        let all_w = cell_w * repeat_x + gap_x * (repeat_x - 1);
        let s_x = (box.width - all_w) / 2;
        let re_x = s_x;
        let re_y = 0;

        let cell: any;
        for (let i = 0; i < box.numChildren; i++) {
            cell = box.getChildAt(i);
            cell.x = re_x;
            cell.y = re_y;

            if ((i + 1) % repeat_x == 0) {
                re_y += cell_h + gap_y;
                re_x = s_x;
            } else {
                re_x += cell_w + gap_x;
            }
        }
    }

    _img_bg: Laya.Image;
    _icon_bg: Laya.Image;
    _img_title_bg: Laya.Image;
    _content_bg: Laya.Image;
    _text_bg: Laya.Image;
    _btn_up_box: Laya.Box;
    _btn_up: Laya.Image;
    _btn_down_box: Laya.Box;
    _btn_down: Laya.Image;
    _lb_skill_name: Laya.Label;
    _lb_max_tip: Laya.Label;
    _lb_lock_tip: Laya.Label;
    _btn_levelup: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay: Laya.Label;
    _Image1: Laya.Image;
    _group_item: Laya.Box;
    _group_attr_cur: Laya.HBox;
    _Label1: Laya.Label;
    _lb_cur_attr: Laya.Label;
    _group_attr_next: Laya.HBox;
    _Label2: Laya.Label;
    _lb_next_attr: Laya.Label;
    _Group1: Laya.Box;
    _tx_desc1: Laya.Text;
    _img_icon: Laya.Image;
    _tx_desc2: Laya.Text;
    _tx_desc3: Laya.Text;
    _scroller: Laya.Panel;
    Content: Laya.Box;
    _fight_con: Laya.HBox;
    public GetComponents() {
        [
            this._img_bg, 
            this._icon_bg, 
            this._img_title_bg, 
            this._content_bg, 
            this._text_bg, 
            this._btn_up_box, 
            this._btn_up, 
            this._btn_down_box, 
            this._btn_down, 
            this._lb_skill_name, 
            this._lb_max_tip, 
            this._lb_lock_tip, 
            this._btn_levelup, 
            this._Image11, 
            this.labelDisplay, 
            this._Image1, 
            this._group_item, 
            this._group_attr_cur, 
            this._Label1, 
            this._lb_cur_attr, 
            this._group_attr_next, 
            this._Label2, 
            this._lb_next_attr, 
            this._Group1, 
            this._tx_desc1, 
            this._img_icon, 
            this._tx_desc2, 
            this._tx_desc3, 
            this._scroller, 
            this.Content,
            this._fight_con
        ] = this.GetChildrenByNames([
            '_img_bg', 
            '_icon_bg', 
            '_img_title_bg', 
            '_content_bg', 
            '_text_bg', 
            '_btn_up_box', 
            '_btn_up', 
            '_btn_down_box', 
            '_btn_down', 
            '_lb_skill_name', 
            '_lb_max_tip', 
            '_lb_lock_tip', 
            '_btn_levelup', 
            '_Image11', 
            'labelDisplay', 
            '_Image1', 
            '_group_item', 
            '_group_attr_cur', 
            '_Label1', 
            '_lb_cur_attr', 
            '_group_attr_next', 
            '_Label2', 
            '_lb_next_attr', 
            '_Group1', 
            '_tx_desc1', 
            '_img_icon', 
            '_tx_desc2', 
            '_tx_desc3', 
            '_scroller', 
            'Content',
            '_fight_con'
        ]);
    }
}
window['GuildSkillView'] = GuildSkillView;
