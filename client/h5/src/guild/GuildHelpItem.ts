import { Alert, Alert_Type } from '../alert/Alert';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Config } from '../common/Config';
import { CustomHeadItem } from '../common/CustomHeadItem';
import { EventName } from '../common/EventName';
import { ResManager } from '../common/ResManager';
import { WordManager } from '../common/WordManager';
import { BaseDungeonModel, DUN_TYPE } from '../commonModel/BaseDungeonModel';
import { BossModel } from '../commonModel/BossModel';
import { BrightSeaModel } from '../commonModel/BrightSeaModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { RoleManager } from '../commonModel/RoleManager';
import { Message } from '../sysInfo/SysInfoController';
import { ColorUtil } from '../util/ColorUtil';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { ErlangParser } from '../util/ErlangParser';
import { HtmlColorTxt, SetHtmlCenter, SetHtmlStyle, TransformLevel, Trim, Util } from '../util/Util';
export class GuildHelpItem extends BaseItemRenderer {
    _model: GuildModel;
    brightSeaModel: BrightSeaModel;
    roleMgr: RoleManager;
    resMgr: ResManager;
    unlock = false;
    is_this = false;
    public WIDTH = 594;
    public HEIGT = 120;
    head: CustomHeadItem;
    data;
    public constructor() {
        super();
        this.base_file = 'guild';
        this.layout_file = 'GuildHelpItem';
        this._model = GuildModel.GetInstance();
        this.brightSeaModel = BrightSeaModel.GetInstance();
        this.roleMgr = RoleManager.GetInstance();
        this.resMgr = ResManager.GetInstance();
        this.load_callback = () => {
            SetHtmlStyle(this._lb_desc1, { c: '#663915', f: 18, w: 300, ww: false });
            SetHtmlStyle(this._lb_desc2, { c: '#663915', f: 18, w: 300, ww: false });
            SetHtmlStyle(this._lb_desc3, { c: '#663915', f: 18, w: 300, ww: false });
            this.InitEvent();
        };

        this.Load();
    }

    public InitEvent() {
        Util.AddClickEvent(
            this._btn_go,
            () => {

                if (!this.data) return

                //协助开放条件
                let sub_key = this.data.type + "@" + this.data.sub_type
                let asssit_sub_open = GuildModel.GetInstance().IsOpenAssist(sub_key)
                if (!asssit_sub_open) {
                    Message.show(`${GuildModel.GetInstance().GetAssistOpenDesc(sub_key)}`)
                    return
                }

                if (this.brightSeaModel.GetAssitLimt()) {
                    Alert.Show('协助奖励已达今日上限。', Alert_Type.Two, () => {
                        this.DoWork();
                    }, null, '确认', '取消'
                    );
                } else {
                    this.DoWork();
                }
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_cancel,
            () => {
                // 璀璨之海 立即夺回
                if (this.data.type == 3) {
                    let extra = this.data.extra[0];
                    this.brightSeaModel.enemy_fight = extra.rober_power;

                    let ser_id = this.roleMgr.GetMainRoleVo().server_unique_id;
                    this.brightSeaModel.LaunchBattle(this.data.target_id, ser_id, this.roleMgr.GetMainRoleId(), 2);
                } else {
                    this._model.Fire(GuildEvent.REQUEST_PROTO, 40403, 'l', this.data.assist_id);
                }
            },
            this,
            true
        );
    }

    public DeleteMe() {
        if (this.head) {
            this.head.DeleteMe();
            this.head = null;
        }
        super.DeleteMe();
    }

    public dataChanged() {
        if (!super.dataChanged()) return;

        let data = this.data;
        let lv = 0;
        this.unlock = false;
        let role_vo = RoleManager.GetInstance().GetMainRoleVo();
        this.is_this = data && data.role_id ? role_vo.role_id == data.role_id : false;
        if (data.type == 1) {
            let mon_desc = '';
            if (data.sub_type == 17) {
                this._lb_module.text = '怨灵首领';
                mon_desc = '怨灵首领争夺层';
                let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.target_cfg_id, false);
                //let hy_str = `${mon_desc}<br>[${bossVo.name}]&nbsp;LV.${bossVo.lv}`
                //this._lb_desc.innerHTML = hy_str
                this.SetHtmlText([mon_desc, `[${bossVo.name}]&nbsp;LV.${bossVo.lv}`]);

                let cfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_boss
                let vo = cfg[data.target_cfg_id];
                let condition = JSON.parse(vo.condition);
                let need_lv = 0;
                let need_sorce = 0;
                let need_eq_type = 0;
                let need_eq_num = 0;
                for (let key in condition) {
                    let element = condition[key];
                    if (element[0] == 'lv') {
                        need_lv = Number(element[1]);
                    } else if (element[0] == 'decoration_rating') {
                        need_sorce = Number(element[1]);
                    } else if (element[0] == 'constellation_suit') {
                        need_eq_type = Number(element[1]);
                        need_eq_num = Number(element[2]);
                    }
                }
                if (role_vo.level < need_lv) {
                    let lv_str = TransformLevel(need_lv);
                    let br_str = lv > 370 ? '\n' : '';
                    this._lb_cond.text = `${lv_str}级${br_str}可解锁`;
                } else {
                    let sorce = 0;
                    let list = GoodsModel.GetInstance().wear_unreal_dic;
                    for (let key in list) {
                        let vo = list[key];
                        if (vo) {
                            sorce = sorce + vo.overall_rating;
                        }
                    }
                    if (sorce < need_sorce) {
                        this._lb_cond.text = `灵饰${WordManager.ConvertNum(need_sorce)}评分`;
                    } else {
                        if (need_eq_type > 0 && need_eq_num > 0) {
                            let num = GoodsModel.GetInstance().GetStarEquipPageNum(need_eq_type, true);
                            this.unlock = num >= need_eq_num;
                            if (!this.unlock) {
                                let page_cfg = Config.PRELOAD_SERVER_CONFIG.config_constellation_page;
                                let info = page_cfg[need_eq_type];
                                this._lb_cond.text = `${Trim(info.normal_name)}套装${need_eq_num}件`; 
                            }
                        } else {
                            this.unlock = true;
                        }
                    }
                }

                this.Premiss();
                //}
            } else {
                let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_type
                let eudemons_boss_cfg = Config.PRELOAD_SERVER_CONFIG.config_eudemons_boss_cfg
                let boss_cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_cfg
                let title = Trim(cfg[data.sub_type].bossname);
                this._lb_module.text = title;
                let vo = null;
                if (data.sub_type == BossModel.BossType.eudaemon) {
                    vo = eudemons_boss_cfg[data.target_cfg_id];
                } else {
                    vo = boss_cfg[data.target_cfg_id];
                }

                let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.target_cfg_id, false);
                let lv_str, br_str;
                if (vo) {
                    let cond = JSON.parse(vo.condition);
                    for (let _tmpi in cond) {
                        var value = cond[_tmpi];
                        if (value[0] == 'lv') {
                            lv = Number(value[1]);
                            break;
                        }
                    }

                    if (data.sub_type == BossModel.BossType.field && vo.layers == 0) {
                        mon_desc = `${title}无限层`;
                    } else {
                        mon_desc = `${title}${vo.layers}层`;
                    }

                    this.unlock = role_vo.level >= lv;
                    lv_str = TransformLevel(lv);
                    br_str = lv > 370 ? '\n' : '';
                    this._lb_cond.text = (!this.unlock && `${lv_str}级${br_str}可解锁`) || '';
                } else {
                    this.unlock = role_vo.level >= bossVo.lv;
                    lv_str = TransformLevel(bossVo.lv);
                    br_str = bossVo.lv > 370 ? '\n' : '';
                    mon_desc = null;
                }
                this._lb_cond.text = (!this.unlock && `${lv_str}级${br_str}可解锁`) || '';
                this.SetHtmlText([mon_desc, `[${bossVo.name}]Lv.${bossVo.lv}`]);
                this._Label2.text = '取消请求';
                this.Premiss();
            }
        } else if (this.data.type == 2) {
            this._Label2.text = '取消请求';
            let dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, data.target_cfg_id, false);
            let dun_name = '';

            let cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_assist;
            let key = this.data.type + "@" + this.data.sub_type
            let vo = Config.GetConfigVo(Config.PRELOAD_SERVER_CONFIG.config_guild_assist.name, key, false, cfg)
            dun_name = vo && vo.desc || ""
            this._lb_module.text = dun_name;
            let cond = ErlangParser.GetInstance().parse(dun_cfg.condition);
            this.SetHtmlText([Trim(dun_cfg.name)])

            let dun_id = null;
            for (let _tmpi in cond) {
                var value = cond[_tmpi];
                if (value[0] == 'lv') {
                    lv = Number(value[1]);
                } else if (value[0] == 'finish_dun_id') {
                    dun_id = Number(value[1]);
                }
            }
            if (role_vo.level < lv) {
                let lv_str = TransformLevel(lv);
                let br_str = lv > 370 ? '\n' : '';
                this._lb_cond.text = `${lv_str}级${br_str}可解锁`;
            } else {
                if (dun_id) {
                    this.unlock = BaseDungeonModel.GetInstance().IsDragonDunDone(dun_id, dun_cfg);
                    if (this.unlock) {
                        this._lb_cond.text = '';
                    } else {
                        dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, dun_id, false);
                        this._lb_cond.text = `需通关\n${Trim(dun_cfg.name)}`;
                    }
                } else {
                    this.unlock = true;
                }
            }
        } else if (this.data.type == 3) {
            // 璀璨之海
            this.unlock = true;
            this._lb_module.text = '璀璨之海';
            this._Label2.text = '立即夺回';
            let extra = this.data.extra[0];
            let role_name = HtmlColorTxt(`${extra.rober_name}`, "'#a376ff'");
            let power = extra.rober_power || 0;

            let goods_name = '';
            let goods_tab = [];
            if (extra.rober_reward) {
                for (let _tmpi in extra.rober_reward) {
                    var info = extra.rober_reward[_tmpi];
                    let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, info.typeId, false);
                    if (goods) {
                        goods_tab[info.typeId] = goods_tab[info.typeId] || [];
                        let goods_data = goods_tab[info.typeId];
                        let color_name = HtmlColorTxt(Trim(goods.goods_name + 'X' + info.count), ColorUtil.GetColorLight(goods.color)) || '';
                        goods_name = color_name;
                        goods_data.rober = goods_name;
                    }
                }
            }

            if (extra.back_reward) {
                for (let _tmpi in extra.back_reward) {
                    var info = extra.back_reward[_tmpi];
                    let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, info.typeId, false);
                    if (goods) {
                        let goods_data = goods_tab[info.typeId] || [];
                        goods_data.back_cnt = info.count;
                    }
                }
            }

            if (goods_tab) {
                let goods_name = '';
                for (let type_id in goods_tab) {
                    var goods_data = goods_tab[type_id];
                    goods_name = goods_name + goods_data.rober || '';
                    if (goods_data.back_cnt) {
                        goods_name = `${goods_name}(已追回${goods_data.back_cnt}个)`;
                    }
                }
            }

            this.SetHtmlText([role_name, `(战力：${String(power)})`, `掠夺了${goods_name}`]);
        } else if (this.data.type == 4) {
            this.unlock = true;
            this._lb_module.text = '斩妖';
            this.SetHtmlText([`斩妖第${this.data.target_cfg_id}关`]);
        }

        this.Premiss();
        this._btn_cancel.visible = this.is_this;

        this._lb_name.text = data.name;
        if (this.head == null) {
            this.head = new CustomHeadItem(this._head);
            //this.head.SetActiveLevel(false)
            this.head.Load();
        }
        let head_data = { role_id: data.role_id, career: data.career, picture: data.pic, picture_ver: data.pic_ver };
        this.head.SetRoleVoData(head_data, null, null, data.level);
    }

    Premiss() {
        this._gp_lock.visible = !this.unlock;
        this._btn_go.visible = this.unlock && !this.is_this;
    }

    SetHtmlText(strs) {
        let temp_len = 0; //真正显示的行数
        for (let i = 0; i < 3; i++) {
            if (i < strs.length) {
                if (strs[i] && strs[i].length > 0) {
                    temp_len++;
                    this['_lb_desc' + (i + 1)].visible = true;
                    this['_lb_desc' + (i + 1)].innerHTML = strs[i];
                    SetHtmlCenter(this['_lb_desc' + (i + 1)], { x: 147, w: 300 });
                } else {
                    this['_lb_desc' + (i + 1)].visible = false;
                }
            } else {
                this['_lb_desc' + (i + 1)].visible = false;
            }
        }

        let gap = 5; //间隔
        let start_y = 50; //第一行的位置
        let txt_size = 18; //字体大小

        let full_h = 3 * txt_size + (3 - 1) * gap;
        let c_y = start_y + full_h / 2;

        let txt_h = temp_len * txt_size + (temp_len - 1) * gap;
        let s_y = c_y - txt_h / 2;
        for (let k = 0; k < temp_len; k++) {
            this['_lb_desc' + (k + 1)].y = s_y + k * (gap + txt_size);
        }
    }

    DoWork() {
        // 璀璨之海
        if (this.data.type == 3) {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GuildHelpTipsView', this.data);
            return;
        }

        if (this.data.is_assist == 0) {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GuildHelpTipsView', this.data);
        } else {
            let cfg2 = this.resMgr.GetGameConfigFromCache(this, 'config_eudemons_boss_cfg', false);
            let cfg3 = this.resMgr.GetGameConfigFromCache(this, 'config_boss_type', false);
            let pos = BossModel.GetInstance().GetBossPos(this.data.target_cfg_id, this.data.sub_type, cfg2, cfg3);
            if (pos) {
                this._model.FindWay(pos.x, pos.y);
            }
        }
    }

    _Image1: Laya.Image;
    _Image2: Laya.Image;
    _lb_name: Laya.Label;
    _Image4: Laya.Image;
    _lb_module: Laya.Label;
    _head: Laya.Box;
    _btn_go: Laya.Box;
    _Image3: Laya.Image;
    _Label1: Laya.Label;
    _btn_cancel: Laya.Box;
    _Image41: Laya.Image;
    _Label2: Laya.Label;
    _gp_lock: Laya.Box;
    _Image5: Laya.Image;
    _lb_cond: Laya.Label;
    _lb_desc1: Laya.HTMLDivElement;
    _lb_desc2: Laya.HTMLDivElement;
    _lb_desc3: Laya.HTMLDivElement;
    public GetComponents() {
        [this._Image1, this._Image2, this._lb_name, this._Image4, this._lb_module, this._head, this._btn_go, this._Image3, this._Label1, this._btn_cancel, this._Image41, this._Label2, this._gp_lock, this._Image5, this._lb_cond, this._lb_desc1, this._lb_desc2, this._lb_desc3] = this.GetChildrenByNames(['_Image1', '_Image2', '_lb_name', '_Image4', '_lb_module', '_head', '_btn_go', '_Image3', '_Label1', '_btn_cancel', '_Image41', '_Label2', '_gp_lock', '_Image5', '_lb_cond', '_lb_desc1', '_lb_desc2', '_lb_desc3']);
    }
}
window['GuildHelpItem'] = GuildHelpItem;
