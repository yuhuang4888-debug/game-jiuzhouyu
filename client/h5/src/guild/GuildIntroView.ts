import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { Util } from '../util/Util';
import { GuildIntroItem } from './GuildIntroItem';

export class GuildIntroView extends BaseView1 {

    base_file = 'guild';
    layout_file = 'GuildIntroView';
    layer_value = Enum_UILayer.Activity;
    change_scene_close = true;
    use_background2 = true;
    use_background = true;
    click_bg_toClose = true;
    _ac_list: LoopScrowViewMgr;
    _model:GuildModel;
    _pos;
    _data;
    public constructor() {
        super();
        this._model = GuildModel.GetInstance();
        this.load_callback = () => {
            // this.form.anchorMin = Vector2(0, 0)
            // this.form.anchorMax = Vector2(1, 1)
            // this.form.anchoredPosition = Vector2(0, 0)
            // this.form.sizeDelta = Vector2(0, 0)

            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this._lb_tips.size  = 15
            // }
            this.InitEvent();
            this.LoadSuccess();
        };

        this.open_callback = () => {
            this.OpenAction();
        };

        this.close_callback = () => {
            this.CloseAction();
        };

        this.destroy_callback = () => {
            //Laya.Tween.removeTweens(this._gp_data)

            if (this._ac_list) {
                this._ac_list.DeleteMe();
                this._ac_list = null;
            }
        };
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    public Open(...new_args) {
        let parms = new_args;
        this._data = parms[0];
        this._pos = parms[1];
        super.Open();
    }
    
    InitEvent () {
        this.BindEvent(GuildModel.GetInstance(), GuildEvent.UPDATE_ASSIST_COUNT, (scmd?) => {
            let limit = GuildModel.GetInstance().GetGuildKVCfg(24);
            this._lb_tips.text = '奖励领取次数：' + scmd.assist_count + '/' + limit;
        });
        Util.AddClickEvent(
            this._gp_click,
            () => {
                this.Close();
            },
            this
        );
    };

    LoadSuccess () {
        //SetLocalPosition(this.background2_wnd.transform,
        //- offset_x,
        //- offset_y
        //,0)

        if (this._pos.type == 1) {
            this.display_obj.left = this._pos.left;
            this.display_obj.y = this._pos.y;
        } else if (this._pos.type == 2) {
            this.display_obj.centerX = this._pos.centerX;
            this.display_obj.y = this._pos.y;
        } else {
            this.display_obj.x = this._pos.x;
            this.display_obj.y = this._pos.y;
        }

        //this._gp_data = this._pos
        if (this._data) {
            let data = this._data;
            let p_data = this._model.GetPrestigeData();
            if (p_data) {
                data.content[0] = '每日可最多获得<font color="#b3ff48">' + p_data.prestige_limit + '</font>点善缘值.';
            }

            if (!this._ac_list) {
                this._ac_list = new LoopScrowViewMgr();
                this._ac_list.SetData(this._list, GuildIntroItem, data.content, LoopScrCon.Vertical);
            } else {
                this._ac_list.replaceAll(data.content);
            }

            if (data.tips) {
                GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40404);
            }
        }
    };

    OpenAction () {
        //this._gp_data.x = this._pos.x
        //this._gp_data.y = this._pos.y
        //this._gp_data.scaleY = 0
        //this._gp_data.scaleX = this._gp_data.scaleY
        //Laya.Tween.get(this._gp_data).to({scaleX = 1, scaleY = 1}, 100)
    };

    CloseAction () {
        //Laya.Tween.get(this._gp_data).to({scaleX = 0, scaleY = 0}, 100)
    };

    _gp_click: Laya.Box;
    _gp_data: Laya.Box;
    _Image1: Laya.Image;
    _lb_tips: Laya.Label;
    _list: Laya.Box;
    public GetComponents() {
        [this._gp_click, this._gp_data, this._Image1, this._lb_tips, this._list] = this.GetChildrenByNames(['_gp_click', '_gp_data', '_Image1', '_lb_tips', '_list']);
    }
}
window['GuildIntroView'] = GuildIntroView;
