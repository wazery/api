class APISessionToken
  extend ActiveModel::Naming
  extend Config

  include ActiveModel::Serialization

  attr_reader :deleted
  alias_method :deleted?, :deleted

  # Time to live for application tokens constant
  TTL = app_token_ttl.to_i

  def initialize(existing_token = nil, redis = _redis_connection)
    @token = existing_token
    @redis = redis

    self.last_seen = Time.now unless expired?
  end

  def token
    @token ||= JWTToken.generate
  end

  def ttl
    return 0 if @deleted
    return TTL unless last_seen
    elapsed   = Time.now - last_seen
    remaining = (TTL - elapsed).floor
    remaining > 0 ? remaining : 0
  end

  def last_seen
    @last_seen ||= _retrieve_last_seen
  end

  def last_seen=(as_at)
    _set_with_expire(_last_seen_key, as_at.iso8601)
    @last_seen = as_at
  end

  def hacker
    return if expired?
    @hacker ||= _retrieve_hacker
  end

  def hacker=(hacker)
    _set_with_expire(_hacker_id_key, hacker.id.to_s)
    @hacker = hacker
  end

  def expired?
    ttl < 1
  end

  def valid?
    !expired?
  end

  def delete!
    @redis.del(_last_seen_key, _hacker_id_key)
    @deleted = true
  end

  private

  def _set_with_expire(key, val)
    @redis[key] = val
    @redis.expire(key, TTL)
  end

  def _retrieve_last_seen
    ls = @redis[_last_seen_key]
    ls && Time.parse(ls)
  end

  def _retrieve_hacker
    hacker_id = @redis[_hacker_id_key]
    (HackerSerializer.new Hacker.find(hacker_id), root: false) if hacker_id
  end

  def _last_seen_key
    "session_token/#{token.split('.')[0]}/last_seen"
  end

  def _hacker_id_key
    "session_token/#{token.split('.')[0]}/hacker_id"
  end

  def _redis_connection
    opts = {}
    opts[:driver] = :hiredis
    Redis.new opts
  end
end
