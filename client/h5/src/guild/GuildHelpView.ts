import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseView1 } from '../common/BaseView1';
import { EventName } from '../common/EventName';
import { InstructionType } from '../common/InstructionType';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { LuaSoundManager } from '../common/SoundManager';
import { table } from '../common/table';
import { BrightSeaEvent, BrightSeaModel } from '../commonModel/BrightSeaModel';
import { GuildModel, GuildEvent, GuildDefine } from '../commonModel/GuildModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { Util } from '../util/Util';
import { GuildHelpItem } from './GuildHelpItem';

export class GuildHelpView extends BaseView1 {
    destroy_imm = true;
    use_background = true;
    click_bg_toClose = true;
    is_center = true;
    show_open_movie = true;
    _item: BaseAwardItem;
    _item2: BaseAwardItem;
    _model: GuildModel;
    loopView: LoopScrowViewMgr;
    brightSea_model: BrightSeaModel;
    preload_client_config = {
        ConfigGuild: false
    };

    public constructor() {
        super();
        this.base_file = 'guild';
        this.layout_file = 'GuildHelpView';
        this.layer_value = Enum_UILayer.Activity;
        this._model = GuildModel.GetInstance();
        this.brightSea_model = BrightSeaModel.GetInstance();
        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	let csf = this._Label1.GetComponent("ContentSizeFitter")
            // 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
            // 	this._Label1.size  = 15
            // 	SetSizeDeltaX(this._Label1,150)

            // 	csf = this._Label6.GetComponent("ContentSizeFitter")
            // 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
            // 	this._Label6.size  = 15
            // 	SetSizeDeltaX(this._Label6,150)
            // 	SetAnchoredPositionY(this._Label6,-720)

            // }
        };

        this.destroy_callback = () => {
            this.Clear();
        };
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    Clear() {
        if (this._item) {
            this._item.DeleteMe();
            this._item = null;
        }
        if (this._item2) {
            this._item2.DeleteMe();
            this._item2 = null;
        }

        if (this.loopView) {
            this.loopView.DeleteMe();
            this.loopView = null;
        }
    }

    InitEvent() {
        Util.AddClickEvent(
            this._btn_close,
            () => {
                this.Close();
            },
            this,
            true,
            null,
            null,
            null,
            null,
            LuaSoundManager.SOUND_UI.CLOSE
        );
        Util.AddClickEvent(
            this._btn_help,
            () => {
                this.OpenIntroView();
            },
            this,
            true
        );
        this.BindEvent(this._model, GuildEvent.UPDATE_HELP_LIST, (scmd?) => {
            this.UpdateView();
        });
        this.BindEvent(this._model, GuildEvent.UPDATE_PRESTIGE, (scmd?) => {
            let p_data = this._model.GetPrestigeData();
            if (p_data) {
                this._lb_count2.text = scmd.prestige_day_limit + '/' + p_data.prestige_limit;
            }
        });

        this.BindEvent(this.brightSea_model, BrightSeaEvent.UPDATE_DIAMOND_INFO, (scmd?) => {
            this._lb_count.text = scmd.num + '/' + scmd.max;
        });
    }

    LoadSuccess() {
        this._item = new BaseAwardItem(this._gp_item, null, this.layer_value);
        this._item.Load();
        this._item.SetItemSize(38, 38);
        this._item.SetItembgVisible(false);
        this._item.SetData(35); // GuildDefine.PRESTIGE

        this._item2 = new BaseAwardItem(this._gp_item2, null, this.layer_value);
        this._item2.Load();
        this._item2.SetItemSize(38, 38);
        this._item2.SetItembgVisible(false);
        this._item2.SetData(GuildDefine.PRESTIGE);

        this._model.Fire(GuildEvent.REQUEST_PROTO, 40031);
        this.brightSea_model.Fire(BrightSeaEvent.REQUEST_PROTO, 18916);
        this.UpdateView();
    }

    UpdateView() {
        let real_list = [];
        let scmd = this._model.GetHelpData();
        if (scmd) {
            let list = scmd.assist_list;
            let can_assist = this._model.IsCanOpenAssist();
            for (let _tmpi in list) {
                var vo = list[_tmpi];
                if (vo.type == 1 || vo.type == 2) {
                    if (can_assist) {
                        vo["is_open"] = 1;
                        table.insert(real_list, vo);
                    }
                } else {
                    //璀璨之海直接压入
                    vo["is_open"] = 1;
                    table.insert(real_list, vo);
                }
            }

            if (!this.loopView) {
                this.loopView = new LoopScrowViewMgr();
                this.loopView.SetData(this._list_litems, GuildHelpItem, real_list, LoopScrCon.Vertical);
            } else {
                this.loopView.replaceAll(real_list);
            }

            //test data
            // let data_test=[]
            // for(let i=0;i<12;i++){
            //     data_test.push({name:"我只是测试数据",type:2,sub_type:32,target_cfg_id:5003})
            // }
            // this._ac_item.replaceAll(data_test)
        }
    }

    OpenIntroView() {
        // let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigGuild", true)
        // let data = cfg["intro_cfg"][1]
        // let pos = { type: 2, centerX: -200, y: 700 }
        // GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GuildIntroView", data, pos)

        GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.InstructionGuildHelp);
    }

    _Image1: Laya.Image;
    _Image2: Laya.Image;
    _Image3: Laya.Image;
    _btn_close: Laya.Image;
    _Image5: Laya.Image;
    _btn_help: Laya.Image;
    _Label1: Laya.Label;
    _Label6: Laya.Label;
    _Label2: Laya.Label;
    _Label3: Laya.Label;
    _Label4: Laya.Label;
    _list_litems: Laya.List;
    _Group1: Laya.Box;
    _gp_item: Laya.Box;
    _lb_count: Laya.Label;
    _Label5: Laya.Label;
    _Group2: Laya.Box;
    _gp_item2: Laya.Box;
    _lb_count2: Laya.Label;
    _Label7: Laya.Label;
    _Image2_title: Laya.Image;
    _lb_win_name: Laya.Label;
    public GetComponents() {
        [this._Image1, this._Image2, this._Image3, this._btn_close, this._Image5, this._btn_help, this._Label1, this._Label6, this._Label2, this._Label3, this._Label4, this._list_litems, this._Group1, this._gp_item, this._lb_count, this._Label5, this._Group2, this._gp_item2, this._lb_count2, this._Label7, this._Image2_title, this._lb_win_name] = this.GetChildrenByNames(['_Image1', '_Image2', '_Image3', '_btn_close', '_Image5', '_btn_help', '_Label1', '_Label6', '_Label2', '_Label3', '_Label4', '_list_litems', '_Group1', '_gp_item', '_lb_count', '_Label5', '_Group2', '_gp_item2', '_lb_count2', '_Label7', '_Image2_title', '_lb_win_name']);
    }
}
window['GuildHelpView'] = GuildHelpView;
