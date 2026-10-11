import { BaseView1, OpenMode } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { LuaSoundManager } from '../common/SoundManager';
import { table } from '../common/table';
import { GuildModel } from '../commonModel/GuildModel';
import { Util } from '../util/Util';
import { GuildRBSendItem } from './GuildRBSendItem';

export class GuildRBSendView extends BaseView1 {
    destroy_imm = true;
    use_background = true;
    click_bg_toClose = true;
    is_center = true;
    preload_server_config = { config_guild_daily: false };
    _model: GuildModel;
    loopMgr: LoopScrowViewMgr;

    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildRBSendView';
        this.layer_value = Enum_UILayer.Activity;
        this.open_mode = OpenMode.OpenToggle;
        this._model = GuildModel.GetInstance();
        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };
        this.close_callback = () => {
            if (this.loopMgr) {
                this.loopMgr.DeleteMe();
                this.loopMgr = null;
            }
        };
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
    }

    updateItem() {
        let guild_daily_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_guild_daily', false);
        let data = [];
        for (let key in guild_daily_cfg) {
            // [ts2lua]guild_daily_cfg下标访问可能不正确
            let cfg = guild_daily_cfg[key];
            table.insert(data, cfg);
        }
        if (!this.loopMgr) {
            this.loopMgr = new LoopScrowViewMgr();
            this.loopMgr.SetData(this._list_items, GuildRBSendItem, data, LoopScrCon.Vertical);
        } else {
            this.loopMgr.replaceAll(data);
        }
    }

    LoadSuccess() {
        this.updateItem();
    }

    _Image1: Laya.Image;
    _Image2: Laya.Image;
    _btn_close: Laya.Image;
    _Group1: Laya.Box;
    _Image3: Laya.Image;
    _Image4: Laya.Image;
    _Image5: Laya.Image;
    _list_items: Laya.List;
    public GetComponents() {
        [this._Image1, this._Image2, this._btn_close, this._Group1, this._Image3, this._Image4, this._Image5, this._list_items] = this.GetChildrenByNames(['_Image1', '_Image2', '_btn_close', '_Group1', '_Image3', '_Image4', '_Image5', '_list_items']);
    }
}
window['GuildRBSendView'] = GuildRBSendView;
