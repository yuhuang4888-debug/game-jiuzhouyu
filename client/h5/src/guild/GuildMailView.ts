import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { LuaSoundManager } from '../common/SoundManager';
//import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { GuildModel } from '../commonModel/GuildModel';
import { Message } from '../sysInfo/SysInfoController';
import { Util } from '../util/Util';

export class GuildMailView extends BaseView1 {
    use_background = true;
    click_bg_toClose = true;
    is_center = true;
    destroy_imm = true;
    show_open_movie = true;
    input_limit = 120;
    model: GuildModel;

    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildMailView';
        this.layer_value = Enum_UILayer.Activity;
        this.model = GuildModel.GetInstance();
        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        };
        this.preload_client_config = {
            ConfigLanguageMaskEyouEn: false
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
        Util.AddClickEvent(
            this._btn_send,
            () => {
                let title = this.model.GetGuildKVCfg(15);
                // let title_filter = Util.HasFilterWord(this._input.text,this.preload_client_config["ConfigLanguageMaskEyouEn"])
                Util.HasFilterWord(this._input.text, ResManager.GetInstance().GetGameConfigFromCache(this, 'ConfigLanguageMaskEyouEn', true), (title_filter) => {
                    if (title_filter) {
                        Message.show('内容有敏感词');
                    }
                }, 2);
                //FriendModel.GetInstance().Fire(FriendEvent.SEND_GUILD_MAIL, title, this._input.text)
            },
            this,
            true
        );
    }

    LoadSuccess() {
        this._input.maxChars = this.input_limit;
        this._lb_limit.text = this._input.text.length + '/' + this.input_limit;

        this._input.on(Laya.Event.CHANGE, this, () => {
            this._lb_limit.text = this._input.text.length + '/' + this.input_limit;
        });
    }

    _Image1: Laya.Image;
    _Image2_title: Laya.Image;
    _lb_win_name: Laya.Label;
    _Image2: Laya.Image;
    _btn_send: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay1: Laya.Label;
    _btn_close: Laya.Box;
    _Image111: Laya.Image;
    _Image6: Laya.Image;
    _input: Laya.TextInput;
    Text: Laya.Label;
    _lb_limit: Laya.Label;
    public GetComponents() {
        [this._Image1, this._Image2_title, this._lb_win_name, this._Image2, this._btn_send, this._Image11, this.labelDisplay1, this._btn_close, this._Image111, this._Image6, this._input, this.Text, this._lb_limit] = this.GetChildrenByNames(['_Image1', '_Image2_title', '_lb_win_name', '_Image2', '_btn_send', '_Image11', 'labelDisplay1', '_btn_close', '_Image111', '_Image6', '_input', 'Text', '_lb_limit']);
    }
}
window['GuildMailView'] = GuildMailView;
