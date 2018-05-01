# frozen_string_literal: true

class CardTextAnalyzer
  REGEXPS = {
    post_codes: /〒(?<post_codes>( ?\d){3} ?\-( ?\d){4})/,
    addresses: /(?<addresses>(
      北海道|青森県|岩手県|宮城県|秋田県|山形県|福島県|
      茨城県|栃木県|群馬県|埼玉県|千葉県|東京都|神奈川県|
      新潟県|富山県|石川県|福井県|山梨県|長野県|岐阜県|静岡県|愛知県|
      三重県|滋賀県|京都府|大阪府|兵庫県|奈良県|和歌山県|
      鳥取県|島根県|岡山県|広島県|山口県|徳島県|香川県|愛媛県|高知県|
      福岡県|佐賀県|長崎県|熊本県|大分県|宮崎県|鹿児島県|沖縄県
      ).+[市区町村].+)/x,
    phones: /(?<phones>0( ?[\d\-\(\)]){8,}\d)/,
    mails: /(?<mails>[\w+\-.][\w+\-. ]*@[a-z\d\-. ]+\.[a-z ]*[a-z])/,
  }

  attr_reader :lines, :company_id, :post_codes, :addresses, :phones, :mails

  def initialize(text)
    @lines = text.to_s.split("\n")
    company_hash = Company.all.each_with_object({}) do |company, hash|
      hash[company.name] = company.id
    end
    regexp = Regexp.new("(#{company_hash.keys.join('|')})")
    m = regexp.match(text)
    @company_id = m ? company_hash[m.to_s] : nil
    @post_codes = []
    @addresses = []
    @phones = []
    @mails = []
    @lines.each do |line|
      m = REGEXPS[:post_codes].match(line)
      @post_codes << m[:post_codes].gsub(" ", "") if m
      m = REGEXPS[:addresses].match(line)
      @addresses << m[:addresses].gsub(" ", "") if m
      match_target = line
      while (m = REGEXPS[:phones].match(match_target)) do
        @phones << m[:phones].gsub(" ", "").gsub(/[\(\)]/, "-")
        match_target = m.post_match
      end
      m = REGEXPS[:mails].match(line)
      @mails << m[:mails].gsub(" ", "") if m
    end
  end
end
