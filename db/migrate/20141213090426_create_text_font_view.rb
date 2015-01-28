class CreateTextFontView < ActiveRecord::Migration
    def up
        execute <<-SQL
            create view quran.text_font as select concat_ws( ':'::text, '1', s.surah_id, s.ayah_num ) as id, concat_ws( ':', s.surah_id, s.ayah_num ) ayah_key, s.surah_id, s.ayah_num, true as is_hidden, string_agg( s.lhs::text, ' '::text order by s.position ) as text from ( select ayah.surah_id, ayah.ayah_num, concat_ws( '-', c.page_num, c.code_hex ) lhs, c.position from "content"."resource" join quran.word_font c using ( resource_id ) JOIN quran.ayah using (ayah_key) join quran.char_type ct on ct.char_type_id = c.char_type_id left join quran.word w on w.word_id = c.word_id where content.resource.resource_id = '1' order by quran.ayah.surah_id, quran.ayah.ayah_num, c.position ) s group by s.surah_id, s.ayah_num order by s.surah_id, s.ayah_num
        SQL
    end
    def down
        execute <<-SQL
            drop view quran.text_font
        SQL
    end
end