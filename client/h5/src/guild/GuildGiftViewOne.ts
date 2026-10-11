import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { LuaSoundManager } from '../common/SoundManager';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { Util } from '../util/Util';

export class GuildGiftViewOne extends BaseView1 {
    use_background = true;
    click_bg_toClose = true;
    is_center = true;
    show_open_movie = true;
    destroy_imm = true;
    _model: GuildModel;
    item_list: BaseAwardItem[];
    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildGiftViewOne';
        this.preload_server_config = { config_guild_prestige: false };
        this.layer_value = Enum_UILayer.Activity;
        this._model = GuildModel.GetInstance();

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

        this.destroy_callback = () => {
            this.Clear();
        };
    }

    public DeleteMe() {
        super.DeleteMe();
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
                this.Close();
            },
            this,
            true
        );

        this.BindEvent(this._model, GuildEvent.GET_SALARY, () => {
            this._btn_get.visible = false;
            this.red.visible = false;
        });
    }

    LoadSuccess() {
        // let has_get = this._model.GetSalaryStatus();
        // this._btn_get.visible = !has_get;
        // this.red.visible = !has_get;
        // this._Scroller1.hScrollBarSkin = '';
        // this.UpdateView();
    }

    UpdateView() {
        let wid = 96;
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_guild_prestige', false);
        let info_data = this._model.GetPrestigeData();
        let data;
        if (info_data) {
            data = cfg[info_data.title_id];
        } else {
            data = cfg[1];
        }

        if (!this.item_list) {
            this.item_list = [];
        }
        let award_list = JSON.parse(data.rewards);
        for (let key in award_list) {
            var vo = award_list[key];
            let item = this.item_list[key];
            if (!item) {
                item = new BaseAwardItem(this.Content);
                item.Load();
                item.SetItemSize(wid, wid);
                this.item_list[key] = item;
            }
            let type_id = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1]);
            item.SetData(type_id[0], vo[2]);
        }

        //居中布局
        this.Content.width = wid * award_list.length + this.Content.space * (award_list.length - 1);
        this.Content.x = (this._Scroller1.width - this.Content.width) / 2;
    }

    _Image1: Laya.Image;
    _Image2: Laya.Image;
    Image: Laya.Image;
    _btn_close: Laya.Image;
    _Scroller1: Laya.Panel;
    Content: Laya.HBox;
    text: Laya.Label;
    _btn_get: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay: Laya.Label;
    red: Laya.Image;
    title: Laya.Image;
    public GetComponents() {
        [this._Image1, this._Image2, this.Image, this._btn_close, this._Scroller1, this.Content, this.text, this._btn_get, this._Image11, this.labelDisplay, this.red, this.title] = this.GetChildrenByNames(['_Image1', '_Image2', 'Image', '_btn_close', '_Scroller1', 'Content', 'text', '_btn_get', '_Image11', 'labelDisplay', 'red', 'title']);
    }
}

window['GuildGiftViewOne'] = GuildGiftViewOne;
