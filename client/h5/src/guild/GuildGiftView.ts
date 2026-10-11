import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseView1 } from '../common/BaseView1';
import { CommonRuleView } from '../common/CommonRuleView';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { LuaSoundManager } from '../common/SoundManager';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { Util, SetSizeDeltaX } from '../util/Util';
import '../common/CommonRuleView';
import { RedDotController } from '../common/RedDotController';
import { RedKey } from '../common/RedDotDefine';

export class GuildGiftView extends BaseView1 {
    _model: GuildModel;
    click_bg_toClose;
    destroy_callback;
    destroy_imm;
    is_center;
    item_list;
    preload_client_config;
    preload_server_config;
    show_open_movie;
    use_background;

    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildGiftView';
        this.preload_server_config = {
            config_guild_prestige: false
        };
        this.layer_value = Enum_UILayer.Activity;
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.show_open_movie = true;
        this.destroy_imm = true;

        this._model = GuildModel.GetInstance();
        this.item_list = null;

        this.preload_client_config = {
            ConfigGuild: false
        };

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

        this.destroy_callback = () => {
            this.Clear();
        };
    }

    Clear() {
            if (this.item_list) {
                for (let _ in this.item_list) {
                    var v = this.item_list[_];
                    v.DeleteMe();
                    v = null;
                }
                this.item_list = null;
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
                this._btn_get,
                () => {
                this._model.Fire(GuildEvent.REQUEST_PROTO, 40020);
                },
                this,
                true
            );

            Util.AddClickEvent(
                this._btn_help,
                () => {
                    let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'ConfigGuild', true);
                    let ruleView = new CommonRuleView();
                    ruleView.Open(cfg['gift_intro']['content']);
                    ruleView.SetTitle(cfg['gift_intro']['title']);
                },
                this,
                true
            );

        this.BindEvent(this._model, GuildEvent.GET_SALARY, () => {
                this._btn_get.visible = false;
                this._reddot.visible = false;
            });
        this.BindEvent(this._model, GuildEvent.UPDATE_PRESTIGE_DATA, (scmd?) => {
                this.UpdateView();
            });

            this._Scroller1.hScrollBarSkin = '';
    }

    LoadSuccess() {
        let redState = RedDotController.ins.get(RedKey.GUILD_GIFT);
        // let has_get = this._model.GetSalaryStatus();
        this._btn_get.visible = redState;
        this._reddot.visible = redState;

            this._model.Fire(GuildEvent.REQUEST_PROTO, 40030);
    }

    UpdateView() {
        let vo = this._model.GetPrestigeData();
            if (!vo) {
                return;
            }
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_guild_prestige', false);

            let data = cfg[vo.title_id];
            let ndata = cfg[vo.title_id + 1];
            this._lb_title.text = data.title_name;
            let keep_num = this._model.GetGuildKVCfg(22);
            let is_finish = vo.prestige_week >= keep_num;
            this._lb_tips.visible = is_finish;
            this._lb_cond2.text = '本周获得' + keep_num + '善缘可保持';
            // LayoutRebuilder(this._Group1)

            this._lb_cond.text = (ndata && '获得' + ndata.prestige + '善缘值') || '已满级';
            let ratio = ndata ? Math.min(vo.all_prestige / ndata.prestige, 1) : 1;
            SetSizeDeltaX(this._img_progress, ratio * this._img_progress.width);
            this._lb_pro.text = (ndata && vo.all_prestige + '/' + ndata.prestige) || 'MAX';

            if (!this.item_list) {
                this.item_list = [];
            }
            let award_list = JSON.parse(data.rewards);
            for (let key in award_list) {
            let award = award_list[key];
                let item = this.item_list[key];
                if (!item) {
                    item = new BaseAwardItem(this._group_item, null, 'Activity');
                    item.Load();
                    item.SetItemSize(96, 96);
                    this.item_list[key] = item;
                }
            let type_id = GoodsModel.GetInstance().GetMappingTypeId(award[0], award[1]);
            item.SetData(type_id[0], award[2]);
                item.SetVisible(true);
            }

            for (let i = award_list.length + 1; i <= this.item_list.length; i++) {
                let item = this.item_list[i];
                item.SetVisible(false);
            }
    }

    _Image1: Laya.Image;
    _Image2: Laya.Image;
    _Image4: Laya.Image;
    _Image5: Laya.Image;
    _Image6: Laya.Image;
    _Image7: Laya.Image;
    _Image8: Laya.Image;
    _btn_help: Laya.Image;
    _img_progress_bg: Laya.Image;
    _img_progress: Laya.Image;
    _lb_win_name: Laya.Label;
    _Label1: Laya.Label;
    _lb_title: Laya.Label;
    _Label2: Laya.Label;
    _Label3: Laya.Label;
    _lb_cond2: Laya.Label;
    _lb_tips: Laya.Label;
    _lb_cond: Laya.Label;
    _Label4: Laya.Label;
    _lb_pro: Laya.Label;
    _Scroller1: Laya.Panel;
    _group_item: Laya.HBox;
    _btn_close: Laya.Image;
    _btn_get: Laya.Box;
    _img_get: Laya.Image;
    _lb_get: Laya.Label;
    _reddot: Laya.Image;
    public GetComponents() {
        [this._Image1, this._Image2, this._Image4, this._Image5, this._Image6, this._Image7, this._Image8, this._btn_help, this._img_progress_bg, this._img_progress, this._lb_win_name, this._Label1, this._lb_title, this._Label2, this._Label3, this._lb_cond2, this._lb_tips, this._lb_cond, this._Label4, this._lb_pro, this._Scroller1, this._group_item, this._btn_close, this._btn_get, this._img_get, this._lb_get, this._reddot] = this.GetChildrenByNames(['_Image1', '_Image2', '_Image4', '_Image5', '_Image6', '_Image7', '_Image8', '_btn_help', '_img_progress_bg', '_img_progress', '_lb_win_name', '_Label1', '_lb_title', '_Label2', '_Label3', '_lb_cond2', '_lb_tips', '_lb_cond', '_Label4', '_lb_pro', '_Scroller1', '_group_item', '_btn_close', '_btn_get', '_img_get', '_lb_get', '_reddot']);
    }
}

window['GuildGiftView'] = GuildGiftView;
